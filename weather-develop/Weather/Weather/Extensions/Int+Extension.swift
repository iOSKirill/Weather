//
//  Int+Extension.swift
//  Weather
//
//  Created by Kirill Manuilenko on 13.03.23.
//

import Foundation
import UIKit

//MARK: - Int extension -
extension Int {
    func dateFormatter(dateFormat: DateFormats) -> String {
        let time = TimeInterval(self)
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = dateFormat.rawValue
        let strDate = formatter.string(from: date)
        return strDate
    }
}

