//
//  ForecastCell.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 16.Sep.22.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var city: UILabel!
    @IBOutlet weak private var date: UILabel!
    @IBOutlet weak private var maxTemp: UILabel!
    @IBOutlet weak private var conditionName: UILabel!
    @IBOutlet weak private var conditionImage: UIImageView!
    @IBOutlet weak private var minTemp: UILabel!
    
    private var hours = [Hour]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
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
    
    private func setupCollectionView() {
        let key = ForecastCollectionViewCell.reuseIdentifire
        collectionView.register(UINib(nibName: key, bundle: nil), forCellWithReuseIdentifier: key)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupHourCell(hours: [Hour]) {
        self.hours = hours
        collectionView.reloadData()
    }
    
    func setupCell(forecast: ForecastDay, city: String) {
        if let url = URL(string: String("https:\(forecast.day.condition.icon)")) {
            self.downloadImage(from: url)
        }
        self.city.text = city
        date.text = forecast.date
        maxTemp.text = String("maxTº: \(Int(forecast.day.maxtemp_c))Cº")
        minTemp.text = String("minTº: \(Int(forecast.day.mintemp_c))Cº")
        conditionName.text = forecast.day.condition.text
    }

}

extension ForecastCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseIdentifire, for: indexPath) as? ForecastCollectionViewCell else { fatalError() }
        cell.setupCell(hour: hours[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
