//
//  DebugScreenController.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 21.Sep.22.
//

import UIKit

protocol DebugScreenControllerProtocol: AnyObject {
    
}

class DebugScreenController: UIViewController {
    
    var viewModel: DebugViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func clearLocalData(_ sender: Any) {
        viewModel?.clearLocalData()
    }
}

extension DebugScreenController: DebugScreenControllerProtocol {
    
}
