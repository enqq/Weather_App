//
//  WheatherModel.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 10/05/2022.
//

import Foundation
import SwiftyJSON
import UIKit


struct WeatherModel: JsonDecodable{
    let current: ForceastModel
    let hourly: [ForceastModel]
    let daily: [DailyForecastModel]
    
    init?(json: JSON?) {
        guard let currentJson = json?["current"],
              let hourlyJson = json?["hourly"].array,
              let dailyJson = json?["daily"].array
        else {
            return nil
        }
        self.current = ForceastModel.init(json: currentJson)!
        self.hourly = hourlyJson.compactMap(ForceastModel.init)
        self.daily = dailyJson.compactMap(DailyForecastModel.init)
    }
}

struct ForceastModel: JsonDecodable {
    let dt: Date
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
    let clouds: Int
    let visibility: Float
    let icon: String
    
    init?(json: JSON?) {
        guard let dtJson =  json?["dt"].double,
              let tempJson = json?["temp"].float,
              let feels_likeJson = json?["feels_like"].float,
              let pressureJson = json?["pressure"].int,
              let humidityJson = json?["humidity"].int,
              let visibilityJson = json?["visibility"].float,
              let cloudsJson = json?["clouds"].int,
              let iconJson = json?["weather"][0]["icon"].string
        else{
            return nil
        }
        
        self.dt = Date(timeIntervalSince1970: dtJson)
        (self.temp, self.feels_like, self.pressure, self.humidity, self.clouds, self.visibility, self.icon) = (tempJson, feels_likeJson, pressureJson, humidityJson, cloudsJson, visibilityJson, iconJson)
    }
}

struct DailyForecastModel: JsonDecodable {
    let temp: TempTimeOfDay
    let temp_min: Float
    let temp_max: Float
    let feels_like: TempTimeOfDay
    let pressure: Int
    let humidity: Int
    let dt: Date
    let icon: String
    
    func dateFormatter(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: dt)
    }
    
    init?(json: JSON?) {
        
        guard let dtJson = json?["dt"].double,
              let tempJson = json?["temp"],
              let temp_minJson = json?["temp"]["min"].float,
              let temp_maxJson = json?["temp"]["max"].float,
              let feels_likekJson = json?["feels_like"],
              let pressureJson = json?["pressure"].int,
              let humidityJson = json?["humidity"].int,
              let iconJson = json?["weather"][0]["icon"].string
        else{
            return nil
        }
        
        self.temp = TempTimeOfDay.init(json: tempJson)!
        self.feels_like = TempTimeOfDay.init(json: feels_likekJson)!
        self.dt = Date(timeIntervalSince1970: dtJson)
        (self.temp_min, self.temp_max, self.pressure, self.humidity, self.icon) = (temp_minJson, temp_maxJson, pressureJson, humidityJson, iconJson)
    }
}

struct TempTimeOfDay: JsonDecodable {
    let day: Float
    let night: Float
    let eve: Float
    let morn: Float
    
    init?(json: JSON?) {
        
        guard let dayJson = json?["day"].float,
              let nightJson = json?["night"].float,
              let eveJson = json?["eve"].float,
              let mornJson = json?["morn"].float
        else{
            return nil
        }
        
        (self.day, self.night, self.eve, self.morn) = (dayJson, nightJson, eveJson, mornJson)
    }
}
