//
//  ForecastListViewController.swift
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
import SwinjectStoryboard

@testable import ReactiveWeatherApp

class ForecastListViewControllerSpec: QuickSpec {
    
    override func spec() {
        var container: Container!
        
        beforeEach {
            
            container = Container()
            container.register(NetworkingProtocol.self) { _ in MockNetwork() }
                .inObjectScope(ObjectScope.container)
            
            container.register(WeatherApiService.self) { r in
                WeatherApiService(fetcher: r.resolve(NetworkingProtocol.self)!)
            }
            
            container.register(ForecastListViewController.self) { r in
                let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
                let controller = storyboard.instantiateViewController(withIdentifier: "ForecastListViewController") as! ForecastListViewController
                
                controller.api = r.resolve(WeatherApiService.self)
                return controller
            }
        }
        
        it("starts fetching weather information.") {
            
            let disposeBag = DisposeBag()
            let network = container.resolve(NetworkingProtocol.self) as! MockNetwork
            let controller = container.resolve(ForecastListViewController.self)!
            
            controller.viewWillAppear(true)
            _ = controller.view // To call viewDidLoad.view
            
            let input: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
            input.asObservable().subscribe({ text in
                if text.isCompleted {
                    return
                }
                controller.searchBar.delegate!.searchBar!(controller.searchBar, textDidChange: text.element!)
                print("controller.searchBar.text = \(controller.searchBar.text ?? "empty")")
            })
            .disposed(by: disposeBag)
            
            input.on(.next("Mos"))
            expect(network.requestCount).toEventually(equal(1))
        }
    }
}
