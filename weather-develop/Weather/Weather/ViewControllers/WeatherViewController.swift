//
//  ViewController.swift
//  Weather
//
//  Created by Kirill Manuilenko on 28.02.23.
//

import UIKit
import SnapKit
import RealmSwift
import CoreLocation
import UserNotifications

//MARK: - Class -
class WeatherViewController: UIViewController {
    
    //MARK: - Property -
    var currentWeather: Current?
    var hourlyWeather: [Current]?
    var dailyWeather: [Daily]?
    let weatherProvider: AlomofireProviderProtocol = AlamofireProvider()
    let realmManager: RealmManagerProtocol = RealmManager()
    let notificationCenter = UNUserNotificationCenter.current()
    let defaults = UserDefaults.standard
    var language = Locale.current.language.languageCode?.identifier ?? "en"
    
    lazy  var locationManager: CLLocationManager =  {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = false
        return manager
    }()
    
    lazy var weatherByLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "locationImage"), for: .normal)
        button.addTarget(self, action: #selector(weatherByLocationAction), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    lazy var weatherByCityNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(weatherByCityNameAction), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.SFProDisplaySemibold, size: 44)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var weatherIcon: UIImageView = {
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var tempWeatherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.SFProDisplaySemibold, size: 44)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var precipitationsWeather: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.SFProDisplayRegular, size: 18)
        label.text = "weatherViewController.Precipitations".localize
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var precipitationsInfoWeather: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.SFProDisplayRegular, size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var weatherCurrentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityNameLabel, weatherIcon, tempWeatherLabel, precipitationsWeather, precipitationsInfoWeather])
        stackView.frame = CGRect(x: .zero, y: .zero, width: .zero, height: 220)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var dailyTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = weatherCurrentStackView
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.key)
        tableView.register(DailyInfoTableViewCell.self, forCellReuseIdentifier: DailyInfoTableViewCell.key)
        tableView.register(DailyHeaderTableViewCell.self, forCellReuseIdentifier: DailyHeaderTableViewCell.key)
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: HourlyTableViewCell.key)
        tableView.register(HourlyHeaderTableViewCell.self, forCellReuseIdentifier: HourlyHeaderTableViewCell.key)
        view.addSubview(tableView)
        return tableView
    }()
    
    //MARK: - Method -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setGradientBackground()
        let dr = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(dr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let nameCity = defaults.string(forKey: "NameCity") else {
            locationManager.startUpdatingLocation()
            return
        }
        weatherByCityNameButton.setImage(UIImage(named: "activeMagnifyingglass"), for: .normal)
        taskAlamofireProvider(nameCity: nameCity)
    }
    
    //Setup constraints
    func setupConstraints() {
        weatherByLocationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.equalToSuperview().inset(20)
            make.height.width.equalTo(30)
        }
        weatherByCityNameButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(25)
        }
        dailyTableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(90)
            make.trailing.leading.equalToSuperview()
        }
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        weatherIcon.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        tempWeatherLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIcon.snp.bottom).inset(5)
            make.centerX.equalToSuperview()
        }
        precipitationsInfoWeather.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Method Task Alamofire Provider -
    func taskAlamofireProvider(nameCity: String) {
        Task {
            do {
                let coordinateByName = try await self.weatherProvider.getCoordinatesByName(nameCity: nameCity)
                guard let lat = coordinateByName.first?.lat, let lon = coordinateByName.first?.lon else {
                    weatherByCityNameButton.setImage(UIImage(named: "magnifyingglass"), for: .normal)
                    alertErrorWeatherByCityName()
                    return
                }
                defaults.set(nameCity, forKey: "NameCity")
                let weatherForCoordinate = try await self.weatherProvider.getWeatherForCityCoordinates(lat: lat, lon: lon)
                self.realmManager.addWeathertDB(dataWeather: weatherForCoordinate, mapInfoRequest: false)
                guard let icon = weatherForCoordinate.current.weather.first?.icon else { return }

                self.dailyWeather = weatherForCoordinate.daily
                self.hourlyWeather = weatherForCoordinate.hourly
                self.cityNameLabel.text = coordinateByName.first?.localNames[language]
                guard let max = weatherForCoordinate.daily.first?.temp.max, let min = weatherForCoordinate.daily.first?.temp.min else { return }
                self.precipitationsInfoWeather.text = "\("weatherViewController.Max".localize).: \(Int(max))°  \("weatherViewController.Min".localize).: \(Int(min))°"
                self.tempWeatherLabel.text = "\(Int(weatherForCoordinate.current.temp))°"
                self.weatherIcon.image = UIImage(named: icon)
                
                self.dailyTableView.reloadData()
                self.dailyTableView.isHidden = false
                
                sendNotification(model: weatherForCoordinate)
            } catch {
                print(error)
            }
        }
    }
    
    //MARK: - Method Local Notification -
    func sendNotification(model: WeatherModel) {
        notificationCenter.delegate = self
        notificationCenter.removeAllPendingNotificationRequests()
        model.hourly.filter( { $0.weather.first?.main == .rain || $0.weather.first?.main == .snow || $0.weather.first?.main == .thunderstorm}).forEach{ i in
            notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { isAuthorized, error in
                //Content
                let content = UNMutableNotificationContent()
                guard let weatherMain = i.weather.first?.main else { return }
                content.title = "Weather"
                content.body = "\(weatherMain) at \(i.dt.dateFormatter(dateFormat: .hourlyFull))"
                //Date Components
                var dateComponents = DateComponents()
                dateComponents.hour = Int((i.dt - 30*60).dateFormatter(dateFormat: .hourly))
                dateComponents.minute = 30
//                let time = TimeInterval(i.dt)
//                let calendar = Calendar.current
//                let date = calendar.date(byAdding: .minute, value: -20, to: Date(timeIntervalSince1970: time))
//                print(date)
//                guard let date = date else { return }
//                var dateComponents = calendar.dateComponents([.hour,.minute], from: date)
//                print(dateComponents)
                //Trigger
                let trigger = UNCalendarNotificationTrigger(dateMatching:  dateComponents, repeats: false)
                //Identifier notification
                let identifier = "notification\(i)"
                //Request
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                self.notificationCenter.add(request)
            }
        }
    }
    
    func alertWeatherByCityName() {
        let alert = UIAlertController(title: "weatherViewController.SearchByCity".localize, message: "weatherViewController.EnterTheNameOfTheCity".localize, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "weatherViewController.Ok" .localize, style: .default) { [self] _ in
            guard let nameCity = alert.textFields?.first?.text, !nameCity.isEmpty else {
                self.alertErrorWeatherByCityName()
                return
            }
            self.taskAlamofireProvider(nameCity: nameCity)
            weatherByLocationButton.setImage(UIImage(named: "locationImage"), for: .normal)
            weatherByCityNameButton.setImage(UIImage(named: "activeMagnifyingglass"), for: .normal)
        }
        let cancelButton = UIAlertAction(title: "weatherViewController.Cancel".localize, style: .destructive)
        alert.addTextField { [weak self] textField in
            textField.placeholder = "weatherViewController.CityName".localize
            textField.delegate = self
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func alertErrorWeatherByCityName() {
        let alert = UIAlertController(title: nil, message: "The weather does not exist!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "weatherViewController.Ok" .localize, style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }

    //MARK: - Actions -
    @objc func weatherByLocationAction() {
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        weatherByCityNameButton.setImage(UIImage(named: "magnifyingglass"), for: .normal)
        weatherByLocationButton.setImage(UIImage(named: "activeLocationImage"), for: .normal)
    }
    
    @objc func weatherByCityNameAction() {
        alertWeatherByCityName()
    }
}

//MARK: - Extension DailyTableView -
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        }
        return dailyWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyInfoTableViewCell.key, for: indexPath) as? DailyInfoTableViewCell else { return UITableViewCell() }
            guard let dailyWeather = dailyWeather else { return cell }
            cell.configure(model: dailyWeather[indexPath.row])
            cell.backgroundColor = .clear
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyHeaderTableViewCell.key, for: indexPath) as? HourlyHeaderTableViewCell else { return UITableViewCell() }
                guard let dailyWeather = dailyWeather else { return cell }
                cell.configure(model: dailyWeather[indexPath.row])
                cell.backgroundColor = .clear
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.key, for: indexPath) as? HourlyTableViewCell else { return UITableViewCell() }
                cell.hourlyCollectionView.reloadData()
                cell.hourlyWeather = hourlyWeather
                return cell
            }
        }
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyHeaderTableViewCell.key, for: indexPath) as? DailyHeaderTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.key, for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
            guard let dailyWeather = dailyWeather else { return cell }

            guard let icon = dailyWeather[indexPath.row].weather.first?.icon else { return cell }
            cell.iconWeather.image = UIImage(named: icon)

            cell.configure(model: dailyWeather[indexPath.row])
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 47
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 50
            } else {
                return 167
            }
        }
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 5
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: - Extension UNUserNotificationCenterDelegate -
extension WeatherViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

//MARK: - Extension CLLocationManagerDelegate -
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            weatherByCityNameButton.setImage(UIImage(named: "magnifyingglass"), for: .normal)
            weatherByLocationButton.setImage(UIImage(named: "activeLocationImage"), for: .normal)
        } else if locationManager.authorizationStatus == .denied {
            weatherByLocationButton.isEnabled = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defaults.removeObject(forKey: "NameCity")
        guard let lastLocation = locations.last else { return }
        Task {
            do {
                let weatherForCoordinate = try await self.weatherProvider.getWeatherForCityCoordinates(lat: lastLocation.coordinate.latitude, lon: lastLocation.coordinate.longitude)
                self.dailyWeather = weatherForCoordinate.daily
                self.hourlyWeather = weatherForCoordinate.hourly
                guard let icon = weatherForCoordinate.current.weather.first?.icon else { return }
                self.realmManager.addWeathertDB(dataWeather: weatherForCoordinate, mapInfoRequest: false)
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                    if error == nil {
                        if let firstLocation = placemarks?.first,
                           let cityName = firstLocation.locality {
                            self?.cityNameLabel.text = "\(cityName)"
                            self?.locationManager.stopUpdatingLocation()
                        }
                    }
                }
                guard let max = weatherForCoordinate.daily.first?.temp.max, let min = weatherForCoordinate.daily.first?.temp.min else { return }
                self.precipitationsInfoWeather.text = "\("weatherViewController.Max".localize).: \(Int(max))°  \("weatherViewController.Min".localize).: \(Int(min))°"
                self.tempWeatherLabel.text = "\(Int(weatherForCoordinate.current.temp))°"
                self.weatherIcon.image = UIImage(named: icon)
                
                self.dailyTableView.isHidden = false
                self.dailyTableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var characterSet = CharacterSet()
        characterSet.formUnion(.lowercaseLetters)
        characterSet.formUnion(.uppercaseLetters)
        characterSet.formUnion(.whitespaces)
        characterSet.insert(charactersIn: "-")
        let invertedCharacterSet = characterSet.inverted
        let components = string.components(separatedBy: invertedCharacterSet)
        let filtered = components.joined(separator: "")
        return string == filtered
    }
}

