//
//  CityTableViewCell.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 23.Jun.22.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak private var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell(city: String) {
        cityName.text = city
    }

}
