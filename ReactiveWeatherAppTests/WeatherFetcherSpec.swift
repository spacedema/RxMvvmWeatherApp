//
//  WeatherFetcherSpec.swift
//  ReactiveWeatherAppTests
//
//  Created by Сергей Филиппов on 17.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import Swinject
import RxBlocking

@testable import ReactiveWeatherApp

class WeatherFetcherSpec: QuickSpec {
    
    override func spec() {
        
        var container: Container!
        beforeEach {
            container = Container()
            
            container.register(NetworkingProtocol.self) { _ in AlamofireNetworking() }
            container.register(WeatherApiService.self) { r in
                WeatherApiService(fetcher: r.resolve(NetworkingProtocol.self)!)
            }
            
            container.register(NetworkingProtocol.self, name: "stub") { _ in StubNetwork() }
            container.register(WeatherApiService.self, name: "stub") { r in
                WeatherApiService(fetcher: r.resolve(NetworkingProtocol.self, name: "stub")!)
            }
        }
        
        it("returns cities.") {
            
            let results: [SearchResultsCellViewModel]
            let service = container.resolve(WeatherApiService.self)!
            
            results = (try! service.getForecast(city: "Mos").toBlocking().first())!
            expect(results.count) > 1
        }
        
        it("mock service.") {
            
            let results: [SearchResultsCellViewModel]
            let service = container.resolve(WeatherApiService.self, name: "stub")!
            
            results = (try! service.getForecast(city: "Cheboksary").toBlocking().first())!
            expect(results.count) == 1
            expect(results[0].weatherInCity.id) == 569696
            expect(results[0].weatherInCity.temp) > 0
        }
    }
}
