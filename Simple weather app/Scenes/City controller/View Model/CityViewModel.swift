//
//  CityViewModel.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 27.Jul.22.
//

import Foundation

protocol CityViewModelProtocol {
    func getCityList() -> [City]
    func getCurrentCity() -> String
    func filteredContentForSearchText(_ searchText: String)
    func getFilteredCity() -> [City]
    func setCurrentCity(_ city: String)
    func searchCurrentLocation(lat: Double, lon: Double) -> String
}

class CityViewModel: CityViewModelProtocol {
    
    private weak var viewController: CityViewControllerProtocol?
    private var currentCity: String = ""
    private var filteredCity = [City]()
    
    init(viewController: CityViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func filteredContentForSearchText(_ searchText: String) {
        
        filteredCity = getCityList().filter({(city: City) -> Bool in
            return city.name.lowercased().contains(searchText.lowercased())
        })
    }
    
    func getCityList() -> [City] {
        CityList.cityList
    }
    
    func getCurrentCity() -> String {
        currentCity
    }
    
    func getFilteredCity() -> [City] {
        filteredCity
    }
    
    func setCurrentCity(_ city: String) {
        currentCity = city
    }
    
    func searchCurrentLocation(lat: Double, lon: Double) -> String {
        var currentCity: String = "not determined"
        for city in CityList.cityList {
            if Int(lat) == Int(city.lat) && Int(lon) == Int(city.lon) {
                currentCity = city.name
                break
            }
        }
        return currentCity
    }
    
}
