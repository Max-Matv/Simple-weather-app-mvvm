//
//  WeatherInfoController.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 23.Jun.22.
//

import UIKit

protocol WeatherInfoControllerProtocol: AnyObject {
    func weatherRequest(with response: Weather)
    func offlineRequest(with response: WeatherLocal)
}

class WeatherInfoController: UIViewController {
    
    var viewModel: WeatherInfoProtocol?
    var city: City?
    private var weather: Weather?

    @IBOutlet weak private var temp: UILabel!
    @IBOutlet weak private var conditionImage: UIImageView!
    @IBOutlet weak private var cityName: UILabel!
    @IBOutlet weak private var countryName: UILabel!
    @IBOutlet weak private var regionName: UILabel!
    @IBOutlet weak private var conditionText: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    private var navigationButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        addRequest()
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
           if NetworkMonitor.shared.isConnected {
               print("Connected")
               DispatchQueue.main.async {
                   self.collectionView.reloadData()
               }
           } else {
               print("Not connected")
               DispatchQueue.main.async {
                   self.collectionView.reloadData()
               }
           }
       }
    
    @objc
    private func actionBarButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func getForecast(_ sender: Any) {
        let vc = ForecastViewController.instantiate() as! ForecastViewController
        vc.weather = weather
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addRequest() {
        if NetworkMonitor.shared.isConnected {
            if let city = city {
                viewModel?.addWeatherRequest(city.city)
            }
        }
        else {
            if let city = city {
                viewModel?.addLocalRequest(city.city)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.conditionImage.image = UIImage(data: data)
            }
        }
    }

}

extension WeatherInfoController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if NetworkMonitor.shared.isConnected {
           return viewModel?.getCurrentHour().count ?? 0
        } else {
           return viewModel?.getCurrentHourLocal().count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as? HourCell else {
            fatalError()
        }
        if NetworkMonitor.shared.isConnected {
            cell.setupCell(hour: (viewModel?.getCurrentHour()[indexPath.row])!)
        } else {
            cell.setupLocalCell(hour: (viewModel?.getCurrentHourLocal()[indexPath.row])!)
        }
        
        return cell
    }
    
    
}

extension WeatherInfoController: WeatherInfoControllerProtocol {
    func offlineRequest(with response: WeatherLocal) {
        collectionView.reloadData()
        temp.text = String("\(Int(response.current!.tempC))Cº")
        cityName.text = response.location?.name
        countryName.text = response.location?.country
        regionName.text = response.location?.region
        conditionText.text = response.current!.condition?.text
    }
    
    func weatherRequest(with response: Weather) {
        let weatherIcon = response.current.condition.icon
        if let url = URL(string: String("https:\(weatherIcon)")) {
            self.downloadImage(from: url)
        }
        collectionView.reloadData()
        temp.text = String("\(Int(response.current.temp_c))Cº")
        cityName.text = response.location.name
        countryName.text = response.location.country
        regionName.text = response.location.region
        conditionText.text = response.current.condition.text
        weather = response
    }
}
