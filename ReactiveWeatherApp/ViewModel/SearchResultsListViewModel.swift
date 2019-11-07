//
//  ForecastViewModel.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 04.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultsListViewModel : SearchResultsListViewModelType {
    
    // MARK: Input
    var showCheckedButtonDidTap: PublishSubject<Void> = .init()
    var searchText = BehaviorRelay<String>(value: "")
    
    
    // MARK: Output
    var message: Observable<String> = Observable.just("")
    var cities: Observable<[SearchResultsCellViewModel]> {
        return self.citiesVariable.asObservable()
    }
        
    var isLoading: Observable<Bool> {
        return self.isLoadingVariable.asObservable()
    }
    
    var error: Observable<Error> {
        return self.errorSubject.asObservable()
    }
    

    // MARK: Fields
    private let isLoadingVariable = BehaviorRelay(value: false)
    private let errorSubject = PublishSubject<Error>()
    private let citiesVariable = BehaviorRelay<[SearchResultsCellViewModel]>(value: [])
    private let apiService: WeatherApiService
    private let disposeBag = DisposeBag()
    
    init(api: WeatherApiService) {
        
        self.apiService = api
        bindObservableToFetchCities()
        bindButtonDidTap()
    }
    
    deinit {
        print("SearchResultsViewModel deinit called")
    }
}

extension SearchResultsListViewModel {
    
    private func bindObservableToFetchCities() {
       
        searchText.asObservable()
            .throttle(1, scheduler: MainScheduler.instance)
            .filter { $0.count > 2 }
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in self?.isLoadingVariable.accept(true) })
            // dif between flatMap and flapMapLatest is that flatMapLatest destroys previous calls from sequence
            .flatMapLatest ({ [weak self] query -> Observable<[SearchResultsCellViewModel]> in
                if let this = self {
                    return this.fetchCitiesList(query: query)
                }
            
            return Observable.just([])
        })
        .do(onNext: { [weak self] _ in self?.isLoadingVariable.accept(false) })
        .bind(to: self.citiesVariable)
        .disposed(by: disposeBag)
    }
    
    private func bindButtonDidTap(){
        
        self.message = self.showCheckedButtonDidTap
            .map { [weak self] _ -> String in
                
                if let this = self {
                    return this.geCheckedItems()
                }
                
                return "There are no checked items"
        }
    }
    
    private func fetchCitiesList(query: String) -> Observable<[SearchResultsCellViewModel]> {
        
        if query.isEmpty {
            return Observable.just([])
        }
        
        return apiService
            .getForecast(city: query)
            .catchError {[weak self] error in
                self?.errorSubject.onNext(error)
                return Observable.just([])
            }
    }
    
    public func geCheckedItems() -> String {
        
        let strings = citiesVariable.value
            .filter { $0.isChecked.value }
            .map { $0.mainInfo }
        
        let message = strings.joined(separator: "\r\n")
        if message == "" {
            return "There are no checked items"
        }
        
        return message
    }
}

