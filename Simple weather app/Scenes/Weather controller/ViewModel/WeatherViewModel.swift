//
//  WeatherViewModel.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 31.Jul.22.
//

import Foundation
import RealmSwift

protocol WeatherInfoProtocol {
    func addWeatherRequest(_ city: String)
    func getCurrentHour() -> [Hour]
    func getCurrentHourLocal() -> [HourLocal]
    func addLocalRequest(_ city: String)
}

class WeatherInfoViewModel: WeatherInfoProtocol {
   
    private weak var viewController: WeatherInfoControllerProtocol?
    private var city: City?
    private var currentHour: [Hour] = []
    private var currentHourLocal: [HourLocal] = []
    private var dbManager = DBManager()
    
    init(viewController: WeatherInfoControllerProtocol) {
        self.viewController = viewController
    }
    func getCurrentHourLocal() -> [HourLocal] {
        currentHourLocal
    }
    
    func addLocalRequest(_ city: String) {
        guard let weather = dbManager.obtainDataWeather(city) else { return }
        viewController?.offlineRequest(with: weather)
        currentHourLocal = Array(weather.forecast!.forecastday.first!.hour)
    }
    
    func addWeatherRequest(_ city: String) {
        let cityForURL = city.replacingOccurrences(of: " ", with: "%20")
        let weatherUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=9ca01b9369ff4c158e192827222306&q=\(cityForURL)&days=3&aqi=no&alerts=no")!
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: weatherUrl) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            do{
                let weatherResponse = try JSONDecoder().decode(Weather.self, from: data)
                self.dbManager.updateLocalData(weather: weatherResponse)
                DispatchQueue.main.async { [self] in
                    currentHour = weatherResponse.forecast.forecastday.first!.hour
                    viewController?.weatherRequest(with: weatherResponse)
                }
                
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    
    func getCurrentHour() -> [Hour] {
        currentHour
    }
}
