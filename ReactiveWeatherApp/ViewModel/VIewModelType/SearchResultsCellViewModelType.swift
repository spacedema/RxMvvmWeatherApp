//
//  SearchResultsCellViewModelType.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 10.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchResultsCellViewModelType {
    
    // MARK: Input
    var isChecked: Variable<Bool> { get }
    
    
    // MARK: Output
    var weatherIcon: Observable<Data> { get }
    
}
