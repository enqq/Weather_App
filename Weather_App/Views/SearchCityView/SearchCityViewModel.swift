//
//  SearchCityViewModel.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 18/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

class SearchCityViewModel {
    
    private let userDefaults: UserDefaultsHelper
    
    let searchText = BehaviorSubject<String>(value: "")
    let foundCities: Observable<CitiesModel>
    
    init(apiServices: ApiServices, userDefaultsHelper: UserDefaultsHelper) {
        userDefaults = userDefaultsHelper
        let apiServices = apiServices
        
        foundCities = searchText.asObservable()
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({ (searchString) -> Observable<CitiesModel> in
                guard !searchString.isEmpty else {
                    return Observable.empty()
                }
            return apiServices.searchCity("\(searchString)")
            })
    }
    
    internal func SaveCity(cityName: String, lat: Int, lon: Int){
        userDefaults.addCity(cityName: cityName, lat: lat, lon: lon)
    }
}
