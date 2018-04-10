//
//  FiveDayForecast.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 09.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import SwiftyJSON

class FiveDayForecast {
    
    let dt: Int64
    let temp: Double
    let weather: [Weather]
    
    init?(json: JSON) {
        guard
            let dt = json["dt"].int64,
            let temp = json["main"]["temp"].double,
            let weather = json["weather"].array
            else {
                return nil
        }
        
        self.dt = dt
        self.temp = temp
        self.weather = weather.compactMap(Weather.init)
    }
}
