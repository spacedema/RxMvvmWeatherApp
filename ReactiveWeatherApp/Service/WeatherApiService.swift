//
//  WeatherApiService.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 03.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift
import RxAlamofire

class WeatherApiService {
    static let appId = "6fe95bb8e41b80a33bdabf14d71b0608"
    static let url = "http://api.openweathermap.org/data/2.5/find"
    static let imageUrl = "http://api.openweathermap.org/img/w/"
    static let fiveDayUrl = "http://api.openweathermap.org/data/2.5/forecast/?id=524901&appid=6fe95bb8e41b80a33bdabf14d71b0608"
    
    func getForecast(city: String) -> Observable<[SearchResultsCellViewModel]> {
        
        let params: [String: String] = [
            "q": city,
            "type": "like",
            "sort": "population",
            "units": "metric",
            "appid": WeatherApiService.appId
        ]

        return RxAlamofire
            .json(.get, WeatherApiService.url, parameters: params)
            .flatMap(parseJson)
    }
    
    func get5DayForecast(cityId: Int) -> Observable<[FiveDayForecastCellViewModel]> {
        
        let params: [String: String] = [
            "id": String(cityId),
            "units": "metric",
            "appId": WeatherApiService.appId
        ]
        
        return RxAlamofire
            .json(.get, WeatherApiService.fiveDayUrl, parameters: params)
            .flatMap(parseFiveDayForecastJson)
    }
    
    func getWeatherImage(imageID: String) -> Observable<Data> {
        return RxAlamofire
            .request(.get, WeatherApiService.imageUrl + imageID + ".png")
            .data()
    }
    
    private func parseFiveDayForecastJson(json: Any) -> Observable<[FiveDayForecastCellViewModel]> {
        let viewModels = JSON(json)["list"].array?.compactMap {
            FiveDayForecastCellViewModel(forecast: FiveDayForecast(json: $0)!, api: self)
        }
        return Observable.from(optional: viewModels)
    }
    
    private func parseJson(json: Any) -> Observable<[SearchResultsCellViewModel]> {
        guard let forecast = SearchResults(json: JSON(json)) else {
            return Observable.never()
        }

        let viewModels = forecast.list.map {
            SearchResultsCellViewModel(city: $0, api: self)
        }
        
        return Observable.from(optional: viewModels)
    }
}

