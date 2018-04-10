//
//  CityWeatherDetailViewModel.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 06.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FiveDayForecastDetailViewModel : FiveDayForecastDetailViewModelType {
    
    // MARK: Input
    let submitButtonDidTap: PublishSubject<Void> = .init()
    let noteVariable: Variable<String> = Variable.init("")
    
    
    // MARK: Output
    var fiveDayForecast: Observable<[FiveDayForecastCellViewModel]> = Observable.just([])
    var weatherIcon: Observable<Data> = Observable.just(Data())
    var canSubmitNote: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    var isLoading: Observable<Bool> {
        return self.isLoadingVariable.asObservable()
    }
    var error: Observable<Error> {
        return self.errorSubject.asObservable()
    }
    
    
    // MARK: Properties
    private let isLoadingVariable = Variable(false)
    private let errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    var mainInfo: String
    var descript: String
    var details: String
    var apiService: WeatherApiService
    
    init(api: WeatherApiService, city: Forecast) {
        self.apiService = api
        self.mainInfo = "\(city.name), \(city.country.uppercased())"
        self.descript = "\(city.weather[0].description)"
        self.details = "\(city.temp), wind \(city.wind) m/s, \(city.pressure) hpa"
        self.weatherIcon = apiService.getWeatherImage(imageID: city.weather[0].icon)
        self.fiveDayForecast = fetchFiveDayForecast(cityId: city.id)
        
        bind()
    }
    
    deinit {
        print("FiveDayForecastDetailViewModel deinit called")
    }
}

extension FiveDayForecastDetailViewModel {
    
    private func bind() {
        
        let _ = noteVariable.asObservable()
            .subscribe(onNext: { [weak self] note in
                self?.canSubmitNote.on(.next(!note.isEmpty))
            })
        .disposed(by: disposeBag)
        
        submitButtonDidTap.subscribe({ [weak self] _ in
            print("api post")
            self?.canSubmitNote.on(.next(false))
         })
        .disposed(by: disposeBag)
    }
    
    private func fetchFiveDayForecast(cityId: Int) -> Observable<[FiveDayForecastCellViewModel]> {
    
        return apiService
            .get5DayForecast(cityId: cityId)
            .catchError {[weak self] error in
                self?.errorSubject.onNext(error)
                return Observable.just([])
        }
    }

}
