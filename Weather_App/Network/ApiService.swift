//
//  ApiService.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 10/05/2022.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol JsonDecodable {
    init?(json: JSON?)
}

class ApiServices {
    
    //Base url API OpenWeatherMap
    private let endPoint = "https://api.openweathermap.org/"
    //Api Key OpenWeatherMap &appid={key}
    private let apiKey = "&appid="
    
    //Get Forecast
    func getData<T: JsonDecodable>(_ path: String) -> Observable<T>{
        return Observable<T>.create() { [unowned self] subscribe in
            let urlAbsolute = "\(endPoint)data/2.5/\(path)\(apiKey)"
            print("-----")
            print(urlAbsolute)
            print("-----")
            let task = URLSession.shared.dataTask(with: URL.init(string: urlAbsolute)!) { data, _, _ in
                guard let data = data, let json = try? JSON(data: data) else {
                    print("Error")
                    return
                }
                subscribe.onNext(T.init(json: json)!)
                subscribe.onCompleted()
            }
            task.resume()
            return Disposables.create{
                task.cancel()
            }
        }
    }
    
    //Search city location
    func searchCity<T: JsonDecodable>(_ text: String) -> Observable<T> {
        return Observable.create() { [unowned self] subscribe in
            let urlAbsolute = "\(endPoint)geo/1.0/direct?q=\(text)&limit=10\(apiKey)"
            print("---")
            print(urlAbsolute)
            print("---")
            let task = URLSession.shared.dataTask(with: URL.init(string: urlAbsolute)!) { data, _, _ in
                guard let data = data, let json = try? JSON(data: data) else {
                    print("Error")
                    return
                }
                subscribe.onNext(T.init(json: json)!)
                subscribe.onCompleted()
            }
            task.resume()
            return Disposables.create{
                task.cancel()
            }
        }
    }
}
