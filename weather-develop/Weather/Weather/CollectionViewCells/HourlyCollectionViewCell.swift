//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Kirill Manuilenko on 8.03.23.
//

import UIKit
import SnapKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Property -
    static let key = "HourlyCollectionViewCell"
    
    lazy var weatherInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.SFProDisplayRegular, size: 18)
        contentView.addSubview(label)
        return label
    }()
    
    lazy var weatherTimeInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.SFProDisplayRegular, size: 18)
        contentView.addSubview(label)
        return label
    }()
    
    lazy var iconWeather: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        contentView.addSubview(image)
        return image
    }()
  
    //MARK: - Method -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        contentView.backgroundColor = UIColor(named: "selectedColor")
        contentView.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        weatherInfo.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        iconWeather.snp.makeConstraints { make in
            make.top.equalTo(weatherInfo.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(15)
            make.height.width.equalTo(40)
        }
        weatherTimeInfo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(model: Current) {
        weatherTimeInfo.text = model.dt.dateFormatter(dateFormat: .hourlyFull)
        weatherInfo.text = "\(Int(model.temp))°C"
    }
}
