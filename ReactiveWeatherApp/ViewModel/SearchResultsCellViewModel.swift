//
//  CityViewModel.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 04.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultsCellViewModel : SearchResultsCellViewModelType {
    
    // MARK: Input
    let isChecked = Variable<Bool>(false)
    
    
    // MARK: Output
    var weatherIcon: Observable<Data> = Observable.just(Data())

    
    // MARK: Properties
    private let apiService: WeatherApiService
    private var iconId: String
    var weatherInCity: Forecast
    var mainInfo: String
    var details: String
    var coords: String

    init(city: Forecast, api: WeatherApiService){
        
        self.mainInfo = "\(city.name), \(city.country.uppercased()), \(city.weather[0].description)"
        self.details = "\(Int(city.temp)) C, wind \(city.wind) m/s, \(city.pressure) hpa"
        self.coords = "Geo coords [\(city.coordLat), \(city.coordLon)]"
        self.weatherInCity = city
        self.apiService = api
        self.iconId = city.weather[0].icon
        getIconAsync()
    }
    
    deinit {
        print("SearchResultsCellViewModel deinit called")
    }
    
    private func getIconAsync(){
        weatherIcon = apiService.getWeatherImage(imageID: iconId)
    }
}
