//
//  Weather.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 23.Jun.22.
//

import Foundation


struct Weather: Decodable {
    
    let location: Location
    let current: Current
    let forecast: Forecast
    
}


struct Location: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime: String
}

struct Current: Decodable {
    let last_updated: String
    let temp_c: Double
    let is_day: Int
    let condition: Condition
}

struct Condition: Decodable {
    let text: String
    let icon: String
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
    
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
    let astro: Astro
    let hour: [Hour]
    
}

struct Day: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: Condition
}

struct Astro: Decodable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
}

struct Hour: Decodable {
    let time: String
    let temp_c: Double
    let condition: Condition
}

