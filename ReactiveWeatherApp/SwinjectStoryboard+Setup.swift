//
//  SwinjectStoryboard+Setup.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 18.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc class func setup() {
        
        defaultContainer.storyboardInitCompleted(ForecastListViewController.self) { r, c in
            c.api = r.resolve(WeatherApiService.self)
        }
        
        defaultContainer.register(NetworkingProtocol.self) { _ in AlamofireNetworking() }
        
        defaultContainer.register(WeatherApiService.self) { r in
            WeatherApiService(fetcher: r.resolve(NetworkingProtocol.self)!)
        }
    }
}
