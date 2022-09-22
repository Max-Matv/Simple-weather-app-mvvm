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
    
    lazy var weatherRealm: Realm = {
        let config = Realm.Configuration(schemaVersion: 1)
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
    
    func obtainDataWeather(_ data: String) -> WeatherLocal? {
        var weather: WeatherLocal?
        if let data = weatherRealm.objects(WeatherLocal.self).firstIndex(where: {$0.location?.name == data}) {
            weather = weatherRealm.objects(WeatherLocal.self)[data]
        } else {
            weather = nil
        }
        return weather
    }
    
    func clearData() {
        let data = weatherRealm.objects(WeatherLocal.self)
        do {
           try weatherRealm.write {
                weatherRealm.delete(data)
            }
        } catch {
            print("some error")
        }
        
    }
    
    func updateLocalData(weather: Weather) {
        let forecastday = List<ForecastDayLocal>()
        for day in weather.forecast.forecastday {
            let hr = List<HourLocal>()
            for hour in day.hour {
                let conditionLocal = ConditionLocal(text: hour.condition.text, icon: hour.condition.icon)
                let currentHour = HourLocal(time: hour.time, tempC: hour.temp_c, condition: conditionLocal)
                hr.append(currentHour)
            }
            let conditionLocal = ConditionLocal(text: day.day.condition.text, icon: day.day.condition.icon)
            let dayLocal = DayLocal(maxTemp: day.day.maxtemp_c, minTemp: day.day.mintemp_c, condition: conditionLocal)
            let forecastD = ForecastDayLocal(date: day.date, day: dayLocal, hour: hr)
            forecastday.append(forecastD)
        }
        let forecastLocal = ForecastLocal(forecastday: forecastday)
        let conditionLocal = ConditionLocal(text: weather.current.condition.text, icon: weather.current.condition.icon)
        let currentLocal = CurrentLocal(tempC: weather.current.temp_c, condition: conditionLocal)
        let locationLocal = LocationLocal(name: weather.location.name, region: weather.location.region, country: weather.location.country)
        let weatherLocal = WeatherLocal(location: locationLocal, current: currentLocal, forecast: forecastLocal)
        let fileForUpdate = weatherRealm.objects(WeatherLocal.self).first(where: {$0.location?.name == weather.location.name})
        do {
            if fileForUpdate != nil {
                try weatherRealm.write {
                    weatherRealm.delete(fileForUpdate!)
                    weatherRealm.add(weatherLocal)
                    print("updated")
                }
            } else {
                try weatherRealm.write {
                    weatherRealm.add(weatherLocal)
                    print("added")
                }
            }
            
        } catch {
            print("some error")
        }
    }
}
