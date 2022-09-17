//
//  ForecastCollectionViewCell.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 16.Sep.22.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var date: UILabel!
    @IBOutlet weak private var conditionImage: UIImageView!
    @IBOutlet weak private var temp: UILabel!
    
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

    func setupCell(hour: Hour) {
        if let url = URL(string: String("https:\(hour.condition.icon)")) {
            self.downloadImage(from: url)
        }
        date.text = hour.time
        temp.text = String("\(Int(hour.temp_c))Cº")
    }

}
