//
//  ForecastViewController.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 27.Jun.22.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    var city = ""
    private var forecast: [ForecastDay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        addWeatherRequest()
    }
    
    private func addWeatherRequest() {
        let weatherUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=9ca01b9369ff4c158e192827222306&q=\(city)&days=6&aqi=no&alerts=no")!
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
                    forecast = weatherResponse.forecast.forecastday
                    tableView.reloadData()
                }
                
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        dataTask.resume()
    }

}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastCell else {
            fatalError()
        }
        cell.setupCell(forecast: forecast[indexPath.row])
        return cell
    }
    
    
}
