//
//  ForecastCell.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 27.Jun.22.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak private var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(forecast: ForecastDay) {
        dateLabel.text = forecast.date
    }

}
