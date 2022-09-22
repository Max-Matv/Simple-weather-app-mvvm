//
//  HourCell.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 27.Jun.22.
//

import UIKit

class HourCell: UICollectionViewCell {
    
    @IBOutlet weak private var temp: UILabel!
    @IBOutlet weak private var conditionImage: UIImageView!
    @IBOutlet weak private var time: UILabel!
    
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
    
    func setupLocalCell(hour: HourLocal) {
        temp.text = String("\(Int(hour.tempC))Cº")
        time.text = hour.time
    }
    
    func setupCell(hour: Hour) {
        if let url = URL(string: String("https:\(hour.condition.icon)")) {
            self.downloadImage(from: url)
        }
        temp.text = String("\(Int(hour.temp_c))Cº")
        time.text = hour.time
    }
    
}
