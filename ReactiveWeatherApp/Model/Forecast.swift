//
//  City.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 03.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import SwiftyJSON

class Forecast {
    let id: Int
    let name: String
    let country: String
    let weather: [Weather]
    let temp: Double
    let pressure: Int
    let wind: Double
    let coordLat: Double
    let coordLon: Double
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let name = json["name"].string,
            let country = json["sys"]["country"].string,
            let temp = json["main"]["temp"].double,
            let pressure = json["main"]["pressure"].int,
            let weather = json["weather"].array,
            let wind = json["wind"]["speed"].double,
            let coordLat = json["coord"]["lat"].double,
            let coordLon = json["coord"]["lon"].double
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.country = country
        self.temp = temp
        self.pressure = pressure
        self.wind = wind
        self.coordLat = coordLat
        self.coordLon = coordLon
        self.weather = weather.compactMap(Weather.init)
    }
}
