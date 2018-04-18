//
//  TableViewController.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 02.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForecastListViewController: UIViewController, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var whoisCheckedButton: UIBarButtonItem!
    
    
    // MARK: Fields
    private var disposeBag: DisposeBag!
    private var viewModel: SearchResultsListViewModel!
    public var api: WeatherApiService!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        disposeBag = DisposeBag()
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel = SearchResultsListViewModel(api: self.api)
        dataBind(viewModel: viewModel)
        dataBindButtons(viewModel: viewModel)
        keyboardHideOnScroll()
    }
    
    private func keyboardHideOnScroll() {
        
        let searchBar = self.searchBar
        
        tableView.rx.contentOffset
            .asDriver()
            .drive(onNext: { _ in
                if searchBar?.isFirstResponder ?? false {
                    _ = searchBar?.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func dataBindButtons(viewModel: SearchResultsListViewModel) {
        
        whoisCheckedButton.rx.tap
            .bind(to: viewModel.showCheckedButtonDidTap)
            .disposed(by: disposeBag)
        
        viewModel.message
            .subscribe(onNext: { [weak self] message in
                self?.showMessage(message)
            })
            .disposed(by: disposeBag)
    }
    
    private func dataBind(viewModel: SearchResultsListViewModel){

        searchBar.rx.text.orEmpty
            .throttle(1, scheduler: MainScheduler.instance)
            .filter { $0.count > 2}
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.cities
            .catchError { [weak self] error in
                self?.handleError(error)
                return Observable.just([])
            }
            .bind(to: tableView.rx.items(cellIdentifier: "forecastListViewCell", cellType: ForecastListViewCell.self)) { (row, element, cell) in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe({ [weak self] error in
                self?.handleError(error.element!)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(SearchResultsCellViewModel.self)
            .subscribe(onNext: { [weak self] value in
                if let this = self {
                   if let detailViewController = this.storyboard?.instantiateViewController(withIdentifier: "ForecastDetailViewController") as? FiveDayForecastDetailViewController  {
                    detailViewController.viewModel = FiveDayForecastDetailViewModel(api: this.api, city: value.weatherInCity)
                        this.navigationController?.pushViewController(detailViewController, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        
        print("ForecastViewController deinit called")
        disposeBag = nil
        viewModel = nil
    }
}
