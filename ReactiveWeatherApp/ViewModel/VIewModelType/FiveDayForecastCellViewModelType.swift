//
//  FiveDayForecastCellViewModelType.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 10.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FiveDayForecastCellViewModelType {
    
    // MARK: Ouptut
    var weatherIcon: Observable<Data> { get }
}
