//
//  TableViewCell.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 02.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ForecastListViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var mainInfo: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var coords: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var isChecked: UISwitch!
    
    // MARK: - Fields
    
    var disposeBag: DisposeBag?
    
    
    // MARK: - Properties
    
    var viewModel: SearchResultsCellViewModel? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else {
                return
            }
            
            mainInfo.text = viewModel.mainInfo
            details.text = viewModel.details
            coords.text = viewModel.coords
            
            (self.isChecked.rx.value <-> viewModel.isChecked).disposed(by: disposeBag)
            
            viewModel.weatherIcon
                .map(UIImage.init)
                .bind(to: iconView.rx.image)
                .disposed(by: disposeBag)
            
            self.disposeBag = disposeBag
        }
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        self.iconView.image = nil
        self.disposeBag = nil
        self.viewModel = nil
    }
    
    deinit {
        print("ForecastListViewCell deinit called")
    }
}
