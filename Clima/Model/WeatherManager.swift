//
//  WeatherManager.swift
//  Clima
//
//  Created by amr ahmed abdel hamied on 2/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather (_ weathermanger : WeatherManager , weather : WeatherModel)
    func didFailWithError (error : Error)
}
struct WeatherManager {
    var delegate : WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ad07c35b2e0ffcb3513a3e0bfad166e1&units=metric"
    func fetchWeather(cityName : String)  {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with : urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees , longitude : CLLocationDegrees)  {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with : urlString)
    }
    
    func performRequest(with urlString : String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJson( safeData){
                        self.delegate?.didUpdateWeather(self , weather: weather)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJson(_ weatherData : Data) -> WeatherModel?  {
        let decoder = JSONDecoder()
        do {
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let weather = WeatherModel(cityName: name, temperature: temp, conditionId: id)
            return weather
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
    
    
    
}
