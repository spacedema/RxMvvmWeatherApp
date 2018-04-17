//
//  NetworkingProtocol.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 17.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkingProtocol {
       
    func fetchForecast(forCity city: String, response: @escaping (Any) -> Observable<[SearchResultsCellViewModel]>) -> Observable<[SearchResultsCellViewModel]>
    
    func fetchFiveDayForecast(forCityId id: Int, response: @escaping (Any) -> Observable<[FiveDayForecastCellViewModel]>) -> Observable<[FiveDayForecastCellViewModel]>
    
    func fetchImage(forImageId id: String) -> Observable<Data>
}
