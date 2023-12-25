//
//  RealmManager.swift
//  Weather
//
//  Created by Kirill Manuilenko on 12.03.23.
//

import Foundation
import RealmSwift
import CoreLocation

//MARK: - Protocol -
protocol RealmManagerProtocol {
    var realm: Realm { get }
    func addWeathertDB(dataWeather: WeatherModel, mapInfoRequest: Bool)
}

//MARK: - Class -
class RealmManager: RealmManagerProtocol {
    
    //MARK: - Property -
    var realm = try! Realm()
    
    //MARK: - Method -
    func addWeathertDB(dataWeather: WeatherModel, mapInfoRequest: Bool) {
        let time = Date().timeIntervalSince1970
        guard let icon = dataWeather.current.weather.first?.icon, let description = dataWeather.current.weather.first?.description else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: dataWeather.lat, longitude: dataWeather.lon)) { (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?.first,
                   let cityName = firstLocation.locality {
                    let coordinateWeatherDB = CoordinateWeatherDB(name: cityName, lat: dataWeather.lat, lon: dataWeather.lon)
                    let currentWeatherDB = CurrentWeatherDB(temp: dataWeather.current.temp, humidity: dataWeather.current.humidity, wind: dataWeather.current.windSpeed, time: time, icon: icon, descriptionWeather: description, mapInfoRequest: mapInfoRequest, coordinateWeatherDB: coordinateWeatherDB)
                    do {
                        try self.realm.write {
                            self.realm.add(currentWeatherDB)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
