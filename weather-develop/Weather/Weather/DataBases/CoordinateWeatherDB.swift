//
//  WeatherDatabase.swift
//  Weather
//
//  Created by Kirill Manuilenko on 12.03.23.
//

import Foundation
import RealmSwift

//MARK: - Class -
class CoordinateWeatherDB: Object {
   
    //MARK: - Property -
    @Persisted var name: String
    @Persisted var lat: Double
    @Persisted var lon: Double
    
    convenience init(name: String, lat: Double, lon: Double) {
        self.init()
        self.name = name
        self.lat = lat
        self.lon = lon
    }
}
