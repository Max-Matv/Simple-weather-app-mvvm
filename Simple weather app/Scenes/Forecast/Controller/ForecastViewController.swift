//
//  ForecastViewController.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 16.Sep.22.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    
    var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let key = ForecastCell.reuseIdentifire
        collectionView.register(UINib(nibName: key, bundle: nil), forCellWithReuseIdentifier: key)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension ForecastViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weather?.forecast.forecastday.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifire, for: indexPath) as? ForecastCell else {
            fatalError()
        }
        if let weather = weather {
            cell.setupCell(forecast: weather.forecast.forecastday[indexPath.row], city: weather.location.name)
            cell.setupHourCell(hours: weather.forecast.forecastday[indexPath.row].hour)
        }
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
