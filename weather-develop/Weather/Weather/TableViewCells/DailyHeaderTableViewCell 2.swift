//
//  DailyHeaderTableViewCell.swift
//  Weather
//
//  Created by Kirill Manuilenko on 20.03.23.
//

import UIKit
import SnapKit

class DailyHeaderTableViewCell: UITableViewCell {

    //MARK: - Property -
    static let key = "DailyHeaderTableViewCell"
    
    lazy var weatherNextForecast: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Next Forecast"
        label.font = UIFont(name: Constants.SFProDisplayBold, size: 20)
        contentView.addSubview(label)
        return label
    }()
    
    lazy var weatherIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "nextForecast")
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
        weatherNextForecast.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        weatherIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(24)
        }
    }

}
