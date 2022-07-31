//
//  WeatherViewModel.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 31.Jul.22.
//

import Foundation

protocol WeatherInfoProtocol {
    func addWeatherRequest(_ city: String)
    func getCurrentHour() -> [Hour]
}

class WeatherInfoViewModel: WeatherInfoProtocol {
    
    private weak var viewController: WeatherInfoControllerProtocol?
    private var city: String = ""
    private var currentHour: [Hour] = []
    
    init(viewController: WeatherInfoControllerProtocol) {
        self.viewController = viewController
    }
    
    func addWeatherRequest(_ city: String) {
        let cityForURL = city.replacingOccurrences(of: " ", with: "%20")
        let weatherUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=9ca01b9369ff4c158e192827222306&q=\(cityForURL)&days=1&aqi=no&alerts=no")!
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
