//
//  Weather.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 03.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import SwiftyJSON

class Weather {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let main = json["main"].string,
            let description = json["description"].string,
            let icon = json["icon"].string
        else {
                return nil
        }
        
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}
