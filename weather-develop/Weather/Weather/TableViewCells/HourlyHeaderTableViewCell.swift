//
//  DailyHeaderTableViewCell.swift
//  Weather
//
//  Created by Kirill Manuilenko on 20.03.23.
//

import UIKit
import SnapKit

class HourlyHeaderTableViewCell: UITableViewCell {

    //MARK: - Property -
    static let key = "HourlyHeaderTableViewCell"
    
    private lazy var weatherDay: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Constants.SFProDisplayRegular, size: 18)
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var weatherToday: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "hourlyHeaderTableViewCell.Today".localize
        label.font = UIFont(name: Constants.SFProDisplayBold, size: 20)
        contentView.addSubview(label)
        return label
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
        weatherDay.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        weatherToday.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    func configure(model: Daily) {
        weatherDay.text = model.dt.dateFormatter(dateFormat: .monthDay)
    }
}
