//
//  UICollectionViewCell+ReuseIdentifire.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 16.Sep.22.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    static var reuseIdentifire: String {
        String(describing: self)
    }
}
