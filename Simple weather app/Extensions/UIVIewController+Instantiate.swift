//
//  UIVIewController+Instantiate.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 29.Jul.22.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiate() -> UIViewController {
        let identifire = String(describing: self)
        let storyboard = UIStoryboard(name: identifire, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifire)
        return viewController
    }
}
