//
//  StubNetwork.swift
//  ReactiveWeatherAppTests
//
//  Created by Сергей Филиппов on 17.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import ReactiveWeatherApp

struct StubNetwork : NetworkingProtocol {

    private static let json =
    "{\"message\":\"accurate\",\"cod\":\"200\",\"count\":1,\"list\":[{\"id\":569696,\"name\":\"Cheboksary\",\"coord\":{\"lat\":56.1308,\"lon\":47.2447},\"main\":{\"temp\":11,\"pressure\":1015,\"humidity\":32,\"temp_min\":11,\"temp_max\":11},\"dt\":1523986200,\"wind\":{\"speed\":2,\"deg\":160},\"sys\":{\"country\":\"RU\"},\"rain\":null,\"snow\":null,\"clouds\":{\"all\":0},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"Sky is Clear\",\"icon\":\"01n\"}]}]}"
    
    func fetchForecast(forCity city: String, response: @escaping (Any) -> Observable<[SearchResultsCellViewModel]>) -> Observable<[SearchResultsCellViewModel]> {
        
        let data = StubNetwork.json.data(using: String.Encoding.utf8, allowLossyConversion: false)
        return response(data as Any)
    }
    
    func fetchFiveDayForecast(forCityId id: Int, response: @escaping (Any) -> Observable<[FiveDayForecastCellViewModel]>) -> Observable<[FiveDayForecastCellViewModel]> {
        return Observable.just([])
    }
    
    func fetchImage(forImageId id: String) -> Observable<Data> {
        return Observable.just(Data())
    }

}
