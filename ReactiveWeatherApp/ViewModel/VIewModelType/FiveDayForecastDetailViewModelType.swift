//
//  FiveDayForecastDetailViewModelType.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 10.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FiveDayForecastDetailViewModelType {
    
    // MARK: Input
    var noteVariable: Variable<String> { get }
    var submitButtonDidTap: PublishSubject<Void> { get }
    
    
    // MARK: Output
    var weatherIcon: Observable<Data> { get }
    var fiveDayForecast: Observable<[FiveDayForecastCellViewModel]> { get }
    var canSubmitNote: BehaviorSubject<Bool> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
}
