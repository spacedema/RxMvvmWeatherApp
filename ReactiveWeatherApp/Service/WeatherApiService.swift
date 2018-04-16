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
       
    func getForecast(city: String) -> Observable<[SearchResultsCellViewModel]> {
        
        let params: [String: String] = [
            "q": city,
            "type": "like",
            "sort": "population",
            "units": "metric",
            "appid": API.apiKey
        ]

        return RxAlamofire
            .json(.get, Endpoints.Cities.fetch.url, parameters: params)
            .flatMap(parseJson)
    }
    
    func get5DayForecast(cityId: Int) -> Observable<[FiveDayForecastCellViewModel]> {
        
        let params: [String: String] = [
            "id": String(cityId),
            "units": "metric",
            "appId": API.apiKey
        ]
        
        return RxAlamofire
            .json(.get, Endpoints.FiveDayForecast.fetch.url, parameters: params)
            .flatMap(parseFiveDayForecastJson)
    }
    
    func getWeatherImage(imageID: String) -> Observable<Data> {
        
        return RxAlamofire
            .request(.get, Endpoints.Image.fetch.url + imageID + ".png")
            .data()
    }
    

    func submitNoteMock(cityId: Int, note: String) -> Observable<String> {

        return Observable
            .just("'\(note)' for city with id: \(cityId)")
            .delay(5, scheduler: MainScheduler.instance)
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

