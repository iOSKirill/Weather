//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by Kirill Manuilenko on 8.03.23.
//

import UIKit
import SnapKit

class DailyTableViewCell: UITableViewCell {

    //MARK: - Property -
    static let key = "DailyTableViewCell"
    
    private lazy var weatherInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.AlegreyaSansMedium, size: 18)
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var weatherDayInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.AlegreyaSansBold, size: 18)
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var weatherMinTempInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textColor = UIColor(named: "minTempColor")
        label.font = UIFont(name: Constants.AlegreyaSansMedium, size: 18)
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
    
    func setupConstraints() {
        weatherDayInfo.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        iconWeather.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(30)
        }
        weatherMinTempInfo.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        weatherInfo.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(40)
        }
    }
    
    func configure(model: Daily) {
        weatherDayInfo.text = model.dt.dateFormatter(dateFormat: .daily)
        weatherMinTempInfo.text = "\(Int(model.temp.min))°"
        weatherInfo.text = "\(Int(model.temp.day))°"
    }
}
