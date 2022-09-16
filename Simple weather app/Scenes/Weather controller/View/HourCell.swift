//
//  HourCell.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 27.Jun.22.
//

import UIKit

class HourCell: UICollectionViewCell {
    
    @IBOutlet weak private var temp: UILabel!
    @IBOutlet weak private var time: UILabel!
    
    
    func setupCell(hour: Hour) {
        temp.text = String("\(Int(hour.temp_c))Cº")
        time.text = hour.time
    }
    
}
