//
//  MainViewModel.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 10/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {

    let dataUserDefault: Observable<CityModelUserDefaults>
    private let weather: Observable<WeatherModel>
    private let disposeBag = DisposeBag()
    
    let cityName: Observable<String>
    let temperature: Observable<Float>
    let hourlyForecast: Observable<[ForceastModel]>
    let dailyForecast: Observable<[DailyForecastModel]>
    let totalNumbersOfCities: Observable<Int>
    let currentPage = BehaviorSubject<Int>(value: 1)

    let currenPage2 = PublishSubject<Int>()
    
    init(apiServices: ApiServices, userDefaultsHelper: UserDefaultsHelper) {
        let apiService = apiServices
        let userDefaults = userDefaultsHelper
        
        dataUserDefault = currentPage.asObservable()
            .flatMapLatest({ data -> Observable<CityModelUserDefaults> in
                print("data print \(data)")
                let cityData = userDefaults.getCity(forKey: String(data))
                return Observable.just(cityData)
            })
  

        weather = dataUserDefault.asObservable()
            .flatMapLatest({ city -> Observable<WeatherModel> in
                return apiService.getData("onecall?lat=\(city.lat)&lon=\(city.lon)&units=metric&exclude=minutely,alerts")
            })
        
        cityName = dataUserDefault.map({ $0.cityName })
        temperature = weather.map({ $0.current.temp })
        hourlyForecast = weather.map({ $0.hourly })
        dailyForecast = weather.map({ $0.daily })
        totalNumbersOfCities = userDefaults.lastKeyCityObservable
        
        totalNumbersOfCities.subscribe(onNext:{
            if $0 == 1 {
                self.currentPage.onNext(1)
            }
        }).disposed(by: disposeBag)

    }

}
