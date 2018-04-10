//
//  ForecastDetailViewController.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 06.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FiveDayForecastDetailViewController: UIViewController, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var fiveDayForecastTableView: UITableView!
    @IBOutlet weak var submitNoteButton: UIBarButtonItem!
    
    
    // MARK: Fields
    private var disposeBag: DisposeBag!
    var viewModel: FiveDayForecastDetailViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disposeBag = DisposeBag()
        nameLabel.text = viewModel.mainInfo
        descriptionLabel.text = viewModel.descript
        detailsLabel.text = viewModel.details
        
        dataBindMasterObject()
        dataBindNestedTableView()
        dataBindButtons()
    }

    private func dataBindButtons() {
        
        viewModel.canSubmitNote.asObservable()
            .bind(to: submitNoteButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        submitNoteButton.rx.tap
            .bind(to: viewModel.submitButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    private func dataBindMasterObject(){
        viewModel.weatherIcon
            .map(UIImage.init)
            .bind(to: iconView.rx.image)
            .disposed(by: disposeBag)
        
        noteTextField.rx.text.orEmpty
            .throttle(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.noteVariable)
            .disposed(by: disposeBag)
    }
    
    private func dataBindNestedTableView(){
        fiveDayForecastTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    
        viewModel.fiveDayForecast
            .catchError { [weak self] error in
                self?.handleError(error)
                return Observable.just([])
            }
            .bind(to: fiveDayForecastTableView.rx.items(cellIdentifier: "fiveDayForecastListViewCell", cellType: FiveDayForecastListViewCell.self)) { (row, element, cell) in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)
    
        viewModel.error
                .subscribe({ [weak self] error in
                self?.handleError(error.element!)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("FiveDayForecastDetailViewController deinit called")
    }
}
