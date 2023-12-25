//
//  CurrentWeatherDB.swift
//  Weather
//
//  Created by Kirill Manuilenko on 12.03.23.
//

import Foundation
import RealmSwift

//MARK: - Class -
class CurrentWeatherDB: Object {
    
    //MARK: - Property -
    @Persisted var temp: Double
    @Persisted var humidity: Int
    @Persisted var wind: Double
    @Persisted var time: TimeInterval
    @Persisted var icon: String
    @Persisted var mapInfoRequest: Bool
    @Persisted var descriptionWeather: String
    @Persisted var coordinateWeatherDB: CoordinateWeatherDB?
    
    convenience init(temp: Double, humidity: Int, wind: Double, time: TimeInterval, icon: String, descriptionWeather: String, mapInfoRequest: Bool, coordinateWeatherDB: CoordinateWeatherDB) {
        self.init()
        self.temp = temp
        self.humidity = humidity
        self.wind = wind
        self.time = time
        self.icon = icon
        self.mapInfoRequest = mapInfoRequest
        self.descriptionWeather = descriptionWeather
        self.coordinateWeatherDB = coordinateWeatherDB
    }
}
