//
//  CityFile.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 14.Sep.22.
//

import Foundation
import RealmSwift

final class Content: Object {
    @Persisted var city: String
    @Persisted var lat: Double
    @Persisted var lon: Double
    @Persisted var isFavorite: Bool
    
    convenience init(city: String, lat: Double, lon: Double, isFavorite: Bool) {
        self.init()
        self.city = city
        self.lat = lat
        self.lon = lon
        self.isFavorite = isFavorite
    }
    
    convenience init(_ city: City) {
        self.init(city: city.city, lat: city.lat, lon: city.lon, isFavorite: city.isFavorite)
    }
    
}
