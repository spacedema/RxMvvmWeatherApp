//
//  FiveDayForecastViewCell.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 09.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FiveDayForecastListViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    
    // MARK: - Fields
    var disposeBag: DisposeBag?
    
    
    var viewModel: FiveDayForecastCellViewModel? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else {
                return
            }
            
            dateLabel.text = viewModel.date
            descriptionLabel.text = viewModel.description
            
            viewModel.weatherIcon
                .map(UIImage.init)
                .bind(to: weatherImageView.rx.image)
                .disposed(by: disposeBag)
            
            self.disposeBag = disposeBag
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        self.weatherImageView.image = nil
        self.disposeBag = nil
        self.viewModel = nil
    }
    
    deinit {
        print("FiveDayForecastListViewCell deinit called")
    }

}
