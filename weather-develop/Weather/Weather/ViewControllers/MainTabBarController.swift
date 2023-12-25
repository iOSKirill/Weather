//
//  MainTabBarController.swift
//  Weather
//
//  Created by Kirill Manuilenko on 8.03.23.
//

import UIKit

//MARK: - Class -
class MainTabBarController: UITabBarController {

    //MARK: - Method -
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }
    
    func generateTabBar() {
        viewControllers = [generateVC(viewController: WeatherViewController(), title: "mainTabBarController.Weather".localize, image: UIImage(systemName: "house.fill")), generateVC(viewController: GoogleMapViewController(), title: "mainTabBarController.Map".localize, image: UIImage(systemName: "map")),generateVC(viewController: InfoRequestViewController(), title: "mainTabBarController.Info".localize, image: UIImage(systemName: "info.bubble"))]
    }
    
    func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return  viewController
    }
    
    func setTabBarAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(named: "CellColor")
        tabBar.unselectedItemTintColor = UIColor(named: "unselectedItemTintColor")
    }

}

