//
//  CityTableViewCell.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 23.Jun.22.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak private var favoriteButton: UIButton!
    @IBOutlet weak private var cityName: UILabel!
    var buttonPressed: () -> Void = {}
    
    private var favorite: Bool = false {
        didSet {
            favorite == false ? favoriteButton.setImage(UIImage(systemName: "star"), for: .normal) : favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    @IBAction private func favoritePressed(_ sender: UIButton) {
        favorite.toggle()
        buttonPressed()
    }
    
    func setupCell(city: City) {
        cityName.text = city.city
        favorite = city.isFavorite
    }

}
