//
//  Constants.swift
//  Weather
//
//  Created by Kirill Manuilenko on 9.03.23.
//

import Foundation

//MARK: - Struct -
struct Constants {

    //MARK: - OpenWeatherApi Constants -
    static var baseURL = "https://api.openweathermap.org/"
    
    static var getCodingURL: String {
        return baseURL.appending("geo/1.0/direct?")
    }
    
    static var weatherURL: String {
        return baseURL.appending("data/2.5/onecall?")
    }
    
    static let imageURL = "https://openweathermap.org/img/wn/"
    
    //MARK: - Fonts Constants -
    static var SFProDisplayBold: String {
        return "SFProDisplay-Bold"
    }
    
    static var SFProDisplayRegular: String {
        return "SFProDisplay-Regular"
    }
    
    static var SFProDisplaySemibold: String {
        return "SFProDisplay-Semibold"
    }
    
    static var AlegreyaSansBold: String {
        return "AlegreyaSans-Bold"
    }
    
    static var AlegreyaSansMedium: String {
        return "AlegreyaSans-Medium"
    }
}
    
