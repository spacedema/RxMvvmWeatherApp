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
import PKHUD

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
        
        viewModel.submitResult
            .subscribe({ message in
                if !message.isCompleted {
                    HUD.flash(.label(message.element), delay: 2)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .filter { !$0 }
            .subscribe({ _ in
                HUD.hide()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .filter { $0 }
            .subscribe({ _ in
                HUD.show(.progress)
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe({ [weak self] error in
                self?.showMessage((error.element?.localizedDescription)!)
            })
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
