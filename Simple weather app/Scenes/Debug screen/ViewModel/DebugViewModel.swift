//
//  DebugViewModel.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 21.Sep.22.
//

import Foundation

protocol DebugViewModelProtocol {
    func clearLocalData()
}

class DebugViewModel: DebugViewModelProtocol {
    private weak var viewController: DebugScreenControllerProtocol?
    private var dbManager = DBManager()
    
    init(viewController: DebugScreenControllerProtocol) {
        self.viewController = viewController
    }
    
    func clearLocalData() {
        dbManager.clearData()
    }
    
}
