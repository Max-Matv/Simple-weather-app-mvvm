//
//  String+Localizible.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 06.Jul.22.
//

import Foundation


extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
