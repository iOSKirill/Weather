//
//  CurrentModel.swift
//  Weather
//
//  Created by Kirill Manuilenko on 5.03.23.
//

import Foundation

// MARK: - WeatherModel -
struct WeatherModel: Codable {
    let timezone: String?
    let current: Current
    let hourly: [Current]
    let daily: [Daily]
    var lat: Double
    var lon: Double
}

// MARK: - Current -
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let windGust, pop: Double?
    let rain: Rain?
    let snow: Snow?

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop, rain
        case dt
        case snow
    }
}

// MARK: - Rain -
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Snow -
struct Snow: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - WeatherElement -
struct Weather: Codable {
    let id: Int
    let main: Main
    let description, icon: String
}

//MARK: - Enum Main -
enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case mist = "Mist"
    case rain = "Rain"
    case snow = "Snow"
    case thunderstorm  = "Thunderstorm"
}

// MARK: - Daily -
struct Daily: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double
    let snow: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi, snow
    }
}

// MARK: - FeelsLike -
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp -
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}









