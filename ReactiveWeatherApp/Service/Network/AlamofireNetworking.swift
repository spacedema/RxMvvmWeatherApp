//
//  AlamofireNetworking
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 17.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

struct AlamofireNetworking : NetworkingProtocol {
    
    func fetchImage(forImageId id: String) -> Observable<Data> {
        
        return RxAlamofire
            .request(.get, Endpoints.Image.fetch.url + id + ".png")
            .data()
    }
    
    
    func fetchFiveDayForecast(forCityId cityId: Int, response: @escaping (Any) -> Observable<[FiveDayForecastCellViewModel]>) -> Observable<[FiveDayForecastCellViewModel]> {
        
        let params: [String: String] = [
            "id": String(cityId),
            "units": "metric",
            "appId": API.apiKey
        ]
        
        return RxAlamofire
            .json(.get, Endpoints.FiveDayForecast.fetch.url, parameters: params)
            .flatMap(response)
    }
    
    
    func fetchForecast(forCity city: String, response: @escaping (Any) -> Observable<[SearchResultsCellViewModel]>) -> Observable<[SearchResultsCellViewModel]> {
        
        let params: [String: String] = [
            "q": city,
            "type": "like",
            "sort": "population",
            "units": "metric",
            "appid": API.apiKey
        ]
        
        return RxAlamofire
            .json(.get, Endpoints.Cities.fetch.url, parameters: params)
            .flatMap(response)
    }
    
}
