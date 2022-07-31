//
//  WeatherInfoController.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 23.Jun.22.
//

import UIKit

protocol WeatherInfoControllerProtocol: AnyObject {
    func weatherRequest(with response: Weather)
}

class WeatherInfoController: UIViewController {
    
    var viewModel: WeatherInfoProtocol?
    var city: String = ""

    @IBOutlet weak private var temp: UILabel!
    @IBOutlet weak private var conditionImage: UIImageView!
    @IBOutlet weak private var cityName: UILabel!
    @IBOutlet weak private var countryName: UILabel!
    @IBOutlet weak private var regionName: UILabel!
    @IBOutlet weak private var conditionText: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.addWeatherRequest(city)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
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
        viewModel?.getCurrentHour().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as? HourCell else {
            fatalError()
        }
        cell.setupCell(hour: (viewModel?.getCurrentHour()[indexPath.row])!)
        return cell
    }
    
    
}

extension WeatherInfoController: WeatherInfoControllerProtocol {
    func weatherRequest(with response: Weather) {
        let weatherIcon = response.current.condition.icon.dropFirst(2)
        if let url = URL(string: String("https:\(weatherIcon)")) {
            self.downloadImage(from: url)
        }
        collectionView.reloadData()
        temp.text = String(response.current.temp_c)
        cityName.text = response.location.name
        countryName.text = response.location.country
        regionName.text = response.location.region
        conditionText.text = response.current.condition.text
    }
    
    
}
