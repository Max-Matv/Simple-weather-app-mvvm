//
//  ViewControllerFactory.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 29.Jul.22.
//

import Foundation
import UIKit


class ViewControllerFactory {
    
    private init(){}
    
    static func makeViewController() -> UIViewController {
        let controller = CityViewController.instantiate() as! CityViewController
        controller.viewModel = CityViewModel(viewController: controller)
        return controller
    }
}
