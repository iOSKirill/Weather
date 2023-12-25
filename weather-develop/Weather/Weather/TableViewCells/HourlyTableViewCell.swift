//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Kirill Manuilenko on 11.03.23.
//

import UIKit
import SnapKit

class HourlyTableViewCell: UITableViewCell {

    //MARK: - Property -
    static let key = "HourlyTableViewCell"
    let weatherProvider: AlomofireProviderProtocol = AlamofireProvider()
    var hourlyWeather: [Current]?
    
    lazy var hourlyCollectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: .zero, y: .zero, width: .zero, height: 167), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 10
        collectionView.backgroundColor = UIColor(named: "CellColor")
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.key)
        contentView.addSubview(collectionView)
        return collectionView
    }()
    
    //MARK: - Method -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        contentView.backgroundColor =  UIColor(named: "CellColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        hourlyCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

}

//MARK: - Extension HourlyTableViewCell -
extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.key, for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell() }
        guard let hourlyWeather = hourlyWeather else { return cell }

        guard let icon = hourlyWeather[indexPath.row].weather.first?.icon else { return cell }
        cell.iconWeather.image = UIImage(named: icon)
 
        cell.configure(model: hourlyWeather[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 147)
    }
}


