//
//  GoogleMapViewController.swift
//  Weather
//
//  Created by Kirill Manuilenko on 8.03.23.
//

import UIKit
import SnapKit
import Realm
import GoogleMaps

class GoogleMapViewController: UIViewController, GMSMapViewDelegate {
    
    //MARK: - Property -
    let apiGoogleMap = Bundle.main.object(forInfoDictionaryKey: "ApiGoogleMapKey") as? String ?? "Api Error"
    let weatherProvider: AlomofireProviderProtocol = AlamofireProvider()
    let realmManager: RealmManagerProtocol = RealmManager()
    var currentWeather: Current?
    
    //MARK: - Method -
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey(apiGoogleMap)
        let camera = GMSCameraPosition.camera(withLatitude: 54.029, longitude: 27.597, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    //MARK: - Action -
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        Task {
            do {
                let weatherForCoordinate = try await self.weatherProvider.getWeatherForCityCoordinates(lat: coordinate.latitude, lon: coordinate.longitude)
                self.realmManager.addWeathertDB(dataWeather: weatherForCoordinate, mapInfoRequest: true)
                self.currentWeather = weatherForCoordinate.current
                
                let weatherTempView = UIView()
                weatherTempView.backgroundColor = UIColor(named: "CellColor")
                weatherTempView.layer.cornerRadius = 50
                weatherTempView.layer.borderWidth = 5
                weatherTempView.layer.borderColor = UIColor.white.cgColor
             
                let marker = GMSMarker(position: coordinate)
                let weatherTemp = UILabel()
                guard let temp = currentWeather?.temp else { return }
                weatherTemp.text = "\(Int(temp))°"
                weatherTemp.font = UIFont(name: Constants.SFProDisplayBold, size: 18)
                weatherTemp.textColor = .white
                weatherTemp.sizeToFit()
                
                let weatherIcon = UIImageView()
                weatherIcon.contentMode = .scaleAspectFit
                guard let icon = currentWeather?.weather.first?.icon else { return }
                weatherIcon.image = UIImage(named: icon)
                
                let weatherWindSped = UILabel()
                guard let windSpeed = currentWeather?.windSpeed else { return }
                weatherWindSped.text = "\(Int(windSpeed))"
                weatherWindSped.font = UIFont(name: Constants.SFProDisplayBold, size: 18)
                weatherWindSped.textColor = .white
                weatherWindSped.sizeToFit()
                
                let weatherWindSpedIcon = UIImageView()
                weatherWindSpedIcon.contentMode = .scaleAspectFit
                weatherWindSpedIcon.image = UIImage(named: "windSpeedImage")
                
                weatherTempView.addSubview(weatherTemp)
                weatherTempView.addSubview(weatherIcon)
                weatherTempView.addSubview(weatherWindSped)
                weatherTempView.addSubview(weatherWindSpedIcon)
                
                weatherTempView.snp.makeConstraints { make in
                    make.width.height.equalTo(100)
                }
                weatherTemp.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview().inset(10)
                }
                weatherIcon.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.width.equalTo(25)
                }
                weatherWindSped.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(15)
                    make.leading.equalToSuperview().inset(35)
                }
                weatherWindSpedIcon.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(18)
                    make.leading.equalTo(weatherWindSped.snp.trailing).offset(5)
                    make.height.width.equalTo(15)
                }
                
                mapView.animate(toLocation: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
                marker.iconView = weatherTempView
                marker.map = mapView
            } catch {
                print(error)
            }
        }
    }
    
}


