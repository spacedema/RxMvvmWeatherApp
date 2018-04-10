//
//  FiveDayForecastCellViewModel.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 09.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FiveDayForecastCellViewModel : FiveDayForecastCellViewModelType{
    
    // MARK: Output
    var weatherIcon: Observable<Data> = Observable.just(Data())
    
    
    // MARK: Fields
    private let apiService: WeatherApiService
    private var iconId: String
    var date: String
    var description: String
    
    
    init(forecast: FiveDayForecast, api: WeatherApiService){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, hh:mm"
        dateFormatter.locale = Locale.init(identifier: "ru_RU")
        self.date = dateFormatter.string(from: Date(timeIntervalSince1970: Double(forecast.dt)))
        self.description = "\(Int(forecast.temp)) C, \(forecast.weather[0].description)"
        self.apiService = api
        
        self.iconId = forecast.weather[0].icon
        self.getIconAsync()
    }
    
    deinit {
        print("FiveDayForecastCellViewModel deinit called")
    }
    
    public func getIconAsync(){
        weatherIcon = apiService.getWeatherImage(imageID: iconId)
    }
}

