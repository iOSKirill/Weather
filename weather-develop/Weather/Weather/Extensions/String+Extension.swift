//
//  String+Extension.swift
//  Weather
//
//  Created by Kirill Manuilenko on 29.03.23.
//

import Foundation

//MARK: - String extension -
extension String {
    
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
}
