//
//  WeatherApiService.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 03.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class WeatherApiService {
    
    let fetcher: NetworkingProtocol
    
    init(fetcher: NetworkingProtocol) {
        
        self.fetcher = fetcher
    }
    
    func getForecast(city: String) -> Observable<[SearchResultsCellViewModel]> {
        
        return fetcher.fetchForecast(forCity: city, response: parseJson)
        
    }
    
    func get5DayForecast(cityId: Int) -> Observable<[FiveDayForecastCellViewModel]> {
        
        return fetcher.fetchFiveDayForecast(forCityId: cityId, response: parseFiveDayForecastJson)
    }
    
    func getWeatherImage(imageID: String) -> Observable<Data> {
        
        return fetcher.fetchImage(forImageId: imageID)
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

