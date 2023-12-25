//
//  UIViewController+Extension.swift
//  Weather
//
//  Created by Kirill Manuilenko on 25.03.23.
//

import Foundation
import UIKit

extension UIViewController {
    func setGradientBackground() {
        guard let colorTop = UIColor(named: "gradientColorOne")?.cgColor,
              let colorBottom = UIColor(named: "gradientColorTwo")?.cgColor else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}
