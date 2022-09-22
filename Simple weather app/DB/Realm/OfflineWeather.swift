//
//  OfflineWeather.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 18.Sep.22.
//

import Foundation
import RealmSwift

class WeatherLocal: Object {
    
    @Persisted var location: LocationLocal?
    @Persisted var current: CurrentLocal?
    @Persisted var forecast: ForecastLocal?
    
    convenience init(location: LocationLocal, current: CurrentLocal, forecast: ForecastLocal) {
        self.init()
        self.location = location
        self.current = current
        self.forecast = forecast
    }
}

class LocationLocal: Object {
    
    @Persisted var name: String
    @Persisted var region: String
    @Persisted var country: String
    
    convenience init(name: String, region: String, country: String) {
        self.init()
        self.name = name
        self.region = region
        self.country = country
    }
}

class CurrentLocal: Object {
    
    @Persisted var tempC: Double
    @Persisted var condition: ConditionLocal?
    
    convenience init(tempC: Double, condition: ConditionLocal) {
        self.init()
        self.tempC = tempC
        self.condition = condition
    }
}

class ConditionLocal: Object {
    
    @Persisted var text: String
    @Persisted var icon: String
    
    convenience init(text: String, icon: String) {
        self.init()
        self.text = text
        self.icon = icon
    }
}

class ForecastLocal: Object {
    
    @Persisted var forecastday: List<ForecastDayLocal>
    
    convenience init(forecastday: List<ForecastDayLocal>) {
        self.init()
        self.forecastday = forecastday
    }
}

class ForecastDayLocal: Object {
    
    @Persisted var date: String
    @Persisted var day: DayLocal?
    @Persisted var hour: List<HourLocal>
    
    convenience init(date: String, day: DayLocal, hour: List<HourLocal>) {
        self.init()
        self.date = date
        self.day = day
        self.hour = hour
    }
}

class DayLocal: Object {
 
    @Persisted var maxTemp: Double
    @Persisted var minTemp: Double
    @Persisted var condition: ConditionLocal?
    
    convenience init(maxTemp: Double, minTemp: Double, condition: ConditionLocal) {
        self.init()
        self.minTemp = maxTemp
        self.minTemp = minTemp
        self.condition = condition
    }
}

class HourLocal: Object {
    @Persisted var time: String
    @Persisted var tempC: Double
    @Persisted var condition: ConditionLocal?
    
    convenience init(time: String, tempC: Double, condition: ConditionLocal) {
        self.init()
        self.time = time
        self.tempC = tempC
        self.condition = condition
    }
}
