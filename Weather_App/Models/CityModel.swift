//
//  CityModel.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 18/05/2022.
//

import Foundation
import SwiftyJSON

struct CityModel: JsonDecodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String
    
    init?(json: JSON?) {
        guard let name = json?["name"].string,
              let lat = json?["lat"].double,
              let lon = json?["lon"].double,
              let country = json?["country"].string,
              let state = json?["state"].string
        else{
            return nil
        }
        (self.name, self.lat, self.lon, self.country, self.state) = (name, lat, lon, country, state)
    }
}
struct CitiesModel: JsonDecodable {
    let cities: [CityModel]
    init?(json: JSON?) {
        guard let citiesJson = json?.array else {
            return nil
        }
        cities = citiesJson.compactMap(CityModel.init)
    }
}
