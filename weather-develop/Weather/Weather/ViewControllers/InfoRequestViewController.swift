//
//  InfoRequestViewController.swift
//  Weather
//
//  Created by Kirill Manuilenko on 12.03.23.
//

import UIKit
import SnapKit
import RealmSwift

//MARK: - Class -
class InfoRequestViewController: UIViewController {

    //MARK: - Property -
    let realmManager: RealmManagerProtocol = RealmManager()
    var notificationToken: NotificationToken?
    
    lazy var arrayCurrentWeatherDB: [CurrentWeatherDB] = {
        Array(realmManager.realm.objects(CurrentWeatherDB.self)).sorted(by: { $0.time > $1.time })
    }()
    
    lazy var infoRequestTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(InfoRequestTableViewCell.self, forCellReuseIdentifier: InfoRequestTableViewCell.key)
        view.addSubview(tableView)
        return tableView
    }()
    
    //MARK: - Method -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        trackingChangesRealmDB()
        setGradientBackground()
    }
    
    //Observer Realm
    func trackingChangesRealmDB() {
        let results = realmManager.realm.objects(CurrentWeatherDB.self)
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.infoRequestTableView else { return }
            switch changes {
            case .initial:
                self?.arrayCurrentWeatherDB = results.sorted(by: { $0.time > $1.time })
                tableView.reloadData()
            case .update:
                self?.arrayCurrentWeatherDB = results.sorted(by: { $0.time > $1.time })
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    //Setup Constraints
    func setupConstraints() {
        infoRequestTableView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
    //Deinit Observer Realm
    deinit {
        guard let notificationToken = notificationToken else { return }
        notificationToken.invalidate()
    }
    
}

//MARK: - Extension -
extension InfoRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayCurrentWeatherDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoRequestTableViewCell.key, for: indexPath) as? InfoRequestTableViewCell else { return UITableViewCell() }
        cell.configure(arrayCurrentWeatherDB: arrayCurrentWeatherDB[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
}
