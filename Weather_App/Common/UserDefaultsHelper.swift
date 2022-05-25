//
//  UserDefaultsHelper.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 18/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

internal class UserDefaultsHelper {
    
    internal let userDefaults: UserDefaults
    internal let lastKeyCityObservable: Observable<Int>
    
    private var lastKeyCity: Int {
        return userDefaults.integer(forKey: "LastCityKey")
    }
    
    init(){
        self.userDefaults = UserDefaults.standard
        lastKeyCityObservable = userDefaults.rx.observe(Int.self, "LastCityKey").map({$0 ?? 0})
    }
    
    // Get Data
    func getCity(forKey: String) -> CityModelUserDefaults {
        if let data = userDefaults.value(forKey: forKey) as? Data {
            let cityData = try? PropertyListDecoder().decode(CityModelUserDefaults.self, from: data)
            return cityData!
        }
        return CityModelUserDefaults.init()
    }
    
    // Add New City To Memmory
    func addCity(cityName: String, lat: Int, lon: Int){
        let key = lastKeyCity + 1
        let city = CityModelUserDefaults(id: key, cityName: cityName, lat: lat, lon: lon)
        do{
            userDefaults.set(try? PropertyListEncoder().encode(city), forKey: "\(key)")
            userDefaults.set(key, forKey: "LastCityKey")
        } catch {
            print("Error")
        }
    }
    
}

internal class CityModelUserDefaults: Codable {
    let id: Int
    let cityName: String
    let lat: Int
    let lon: Int
    
    init(id: Int, cityName: String, lat: Int, lon: Int){
        (self.id, self.cityName, self.lat, self.lon) = (id, cityName, lat, lon)
    }
    init(){
        (self.id, self.cityName, self.lat, self.lon) = (0, "", 0, 0)
    }
}
