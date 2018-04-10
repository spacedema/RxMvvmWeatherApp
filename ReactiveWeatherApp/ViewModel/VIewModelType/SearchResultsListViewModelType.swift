//
//  SearchResultsListViewModelType.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 10.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchResultsListViewModelType {

    // MARK: Input

    var showCheckedButtonDidTap: PublishSubject<Void> { get }
    var searchText: BehaviorRelay<String> { get }
    
    // MARK: Output
    
    var message: Observable<String> { get }
    var cities: Observable<[SearchResultsCellViewModel]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<Error> { get }
}
