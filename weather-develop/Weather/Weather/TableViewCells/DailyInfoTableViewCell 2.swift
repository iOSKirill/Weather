//
//  DailyInfoTableViewCell.swift
//  Weather
//
//  Created by Kirill Manuilenko on 20.03.23.
//

import UIKit
import SnapKit

class DailyInfoTableViewCell: UITableViewCell {

    //MARK: - Property -
    static let key = "DailyInfoTableViewCell"
    
    lazy var weatherHumidity: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.SFProDisplayBold, size: 14)
        return label
    }()
    
    lazy var weatherHumidityIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "humidityImage")
        return image
    }()
    
    lazy var weatherHumidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherHumidityIcon, weatherHumidity])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        contentView.addSubview(stackView)
        return stackView
    }()
    
    lazy var weatherWindSpeed: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.SFProDisplayBold, size: 14)
        return label
    }()
    
    lazy var weatherWindSpeedIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "windSpeedImage")
        return image
    }()
    
    lazy var weatherWindSpeedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherWindSpeedIcon, weatherWindSpeed])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        contentView.addSubview(stackView)
        return stackView
    }()
    
    lazy var weatherRain: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.SFProDisplayBold, size: 14)
        return label
    }()
    
    lazy var weatherRainIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "rainImage")
        return image
    }()
    
    lazy var weatherRainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherRainIcon, weatherRain])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        contentView.addSubview(stackView)
        return stackView
    }()
    
    //MARK: - Method -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        contentView.backgroundColor = UIColor(named: "CellColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Daily) {
        weatherHumidity.text = "\(model.humidity)%"
        weatherWindSpeed.text = "\(Int(model.windSpeed)) m/s"
        guard let rain = model.rain else { return }
        weatherRain.text = "\(Int(rain))%"
    }
    
    func setupConstraints() {
        weatherHumidityStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        weatherHumidityIcon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        weatherWindSpeedStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        weatherWindSpeedIcon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        weatherRainStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        weatherRainIcon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
    }

}
