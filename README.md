# Weather_App
Simple application shows Forecast Weather current, hourly, five days for specific city. We can search new city and add to list. Application connect to API [OpenWeatherMap](https://openweathermap.org)

## Setup
 First step we must install pods
 
```bash
 pod install 
```
Next we must write api key to ApiService class

```swift
  //Api Key OpenWeatherMap &appid={key}
    private let apiKey = "&appid="
```

## To do
- Managment Cities
- User Setting (Fahrenheit/Celsjusza)
- Additional information about humidity, etc.

## Library

- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [RxCocoa](https://github.com/ReactiveX/RxSwift)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
