//
//  MockNetwork.swift
//  ReactiveWeatherAppTests
//
//  Created by Сергей Филиппов on 18.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//


import Quick
import Nimble
import RxSwift
import Swinject
import RxBlocking

@testable import ReactiveWeatherApp

class MockNetwork: NetworkingProtocol {
    
    var requestCount: Int = 0
    
    func fetchForecast(forCity city: String, response: @escaping (Any) -> Observable<[SearchResultsCellViewModel]>) -> Observable<[SearchResultsCellViewModel]> {
        requestCount += 1
        return Observable.just([])
    }
    
    func fetchFiveDayForecast(forCityId id: Int, response: @escaping (Any) -> Observable<[FiveDayForecastCellViewModel]>) -> Observable<[FiveDayForecastCellViewModel]> {
        return Observable.just([])
    }
    
    func fetchImage(forImageId id: String) -> Observable<Data> {
        return Observable.just(Data())
    }
}
