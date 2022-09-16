//
//  CityViewModel.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 27.Jul.22.
//

import Foundation

protocol CityViewModelProtocol {
    func updateCity(city: City)
    func getCityList() -> [City]
    func getCurrentCity() -> City?
    func filteredContentForSearchText(_ searchText: String)
    func getFilteredCity() -> [City]
    func setCurrentCity(_ city: City)
    func searchCurrentLocation(lat: Double, lon: Double) -> City
}

class CityViewModel: CityViewModelProtocol {
    
    private weak var viewController: CityViewControllerProtocol?
    private var currentCity: City?
    private var filteredCity = [City]()
    private var dbManager = DBManager()
    
    init(viewController: CityViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func filteredContentForSearchText(_ searchText: String) {
        filteredCity = getCityList().filter({(city: City) -> Bool in
            return city.city.lowercased().contains(searchText.lowercased()) || city.isFavorite == true
        })
    }
    
    func updateCity(city: City) {
        dbManager.updateData(city: city)
    }
    
    func getCityList() -> [City] {
        dbManager.obtainData()
    }
    
    func getCurrentCity() -> City? {
        currentCity
    }
    
    func getFilteredCity() -> [City] {
        filteredCity
    }
    
    func setCurrentCity(_ city: City) {
        currentCity = city
    }
    
    func searchCurrentLocation(lat: Double, lon: Double) -> City {
        var currentCity: City?
        for city in dbManager.obtainData() {
            if Int(lat) == Int(city.lat) && Int(lon) == Int(city.lon) {
                currentCity = city
                break
            }
        }
        return currentCity!
    }
    
}
