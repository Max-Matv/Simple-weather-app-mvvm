//
//  City.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 01.Jul.22.
//

import Foundation

struct City {
    let city: String
    let lat: Double
    let lon: Double
    var isFavorite: Bool
}

extension City {
    init(_ city: Content) {
        self.init(city: city.city, lat: city.lat, lon: city.lon, isFavorite: city.isFavorite)
    }
}
