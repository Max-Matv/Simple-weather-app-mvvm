//
//  DBManager.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 14.Sep.22.
//

import Foundation
import RealmSwift

class DBManager {
    
    lazy var cityRealm: Realm = {
        let config = Realm.Configuration(readOnly: false, seedFilePath: Bundle.main.url(forResource: "CityList", withExtension: "realm"))
        let realm = try! Realm(configuration: config)
        return realm
    }()
    
    func obtainData() -> [City] {
        let data = cityRealm.objects(Content.self)
        let preformedData = data.map { City($0)}
        let sortedData = preformedData.sorted(by: {$0.isFavorite && !$1.isFavorite})
        return Array(sortedData)
    }
    
    func updateData(city: City) {
        do {
            let fileForUapdate = cityRealm.objects(Content.self).first(where: {$0.city == city.city})
            try cityRealm.write {
                fileForUapdate?.isFavorite = !city.isFavorite
            }
        } catch {
            print("some error")
        }
    }
}
