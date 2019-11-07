//
//  ViewController.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 09.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func handleError(_ error: Error){
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showMessage(_ message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
