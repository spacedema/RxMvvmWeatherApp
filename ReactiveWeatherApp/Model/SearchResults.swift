//
//  ServiceResponse.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 03.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchResults {
    let message: String
    let cod: String
    let count: Int
    let list: [Forecast]
    
    init?(json: JSON) {
        guard
            let message = json["message"].string,
            let cod = json["cod"].string,
            let count = json["count"].int,
            let list = json["list"].array
        else {
            return nil
        }

        self.message = message
        self.cod = cod
        self.count = count
        self.list = list
            .compactMap (Forecast.init)
    }
}
