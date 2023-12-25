//
//  HistoryTableViewCell.swift
//  Weather
//
//  Created by Kirill Manuilenko on 13.03.23.
//

import UIKit
import SnapKit

class InfoRequestTableViewCell: UITableViewCell {

    //MARK: - Property -
    static let key = "InfoRequestTableViewCell"
    
    private lazy var tempWeather: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.SFProDisplayRegular, size: 80)
        label.textColor = .white
        backCellView.addSubview(label)
        return label
    }()
    
    private lazy var nameCityWeather: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.SFProDisplayBold, size: 20)
        label.textColor = .white
        backCellView.addSubview(label)
        return label
    }()
    
    private lazy var precipitationsWeather: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.SFProDisplayRegular, size: 20)
        label.textColor = .white
        backCellView.addSubview(label)
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFit
        backCellView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var descriptionWeather: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.SFProDisplayRegular, size: 20)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textAlignment = .right
        backCellView.addSubview(label)
        return label
    }()
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "CellColor")
        view.layer.cornerRadius = 17
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var backCellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "selectedColor")
        view.layer.cornerRadius = 17
        cellView.addSubview(view)
        return view
    }()
    
    private lazy var mapOrLocationIcon: UIImageView = {
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        backCellView.addSubview(imageView)
        return imageView
    }()
    
    //MARK: - Method -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        tempWeather.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(30)
        }
        nameCityWeather.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
        precipitationsWeather.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(45)
        }
        weatherIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(10)
            make.width.height.equalTo(140)
        }
        descriptionWeather.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(150)
        }
        cellView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.trailing.equalToSuperview().inset(1)
        }
        backCellView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.trailing.equalToSuperview().inset(2)
        }
        mapOrLocationIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(20)
        }
    }
    
    func configure(arrayCurrentWeatherDB: CurrentWeatherDB) {
        guard let coordinateWeatherDB = arrayCurrentWeatherDB.coordinateWeatherDB else { return }
        nameCityWeather.text = "\(coordinateWeatherDB.name)"
        descriptionWeather.text = "\(arrayCurrentWeatherDB.descriptionWeather)"
        precipitationsWeather.text = "\("infoRequestTableViewCell.Humidity".localize): \(arrayCurrentWeatherDB.humidity)%"
        weatherIcon.image = UIImage(named: arrayCurrentWeatherDB.icon)
        tempWeather.text = "\(Int(arrayCurrentWeatherDB.temp))°"
        guard arrayCurrentWeatherDB.mapInfoRequest == true else {
            mapOrLocationIcon.image = UIImage(named: "locationImage")
            return
        }
        mapOrLocationIcon.image = UIImage(systemName: "map")
    }

}
