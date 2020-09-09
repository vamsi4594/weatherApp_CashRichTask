//
//  WeatherManager.swift
//  weatherApp_CashRichTask
//
//  Created by Mac on 09/09/20.
//  Copyright © 2020 Vamsi KrishnaT hanikanti. All rights reserved.
//

import Foundation
import CoreLocation

//CREATING PROTOCOLS FOR WEATHER MANAGER
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    // OPEN WEATHER MAP URL AND API KEY
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=06325e8179f31d5937f5bcb23c5166ac&units=metric"
    
    // ASSIGNING DELEGATE
    var delegate : WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String)
    {
        // ADDING GIVEN CITY NAME
        let URLString = "\(weatherUrl)&q=\(cityName)"
        
        // CALLING FUNCTION TO SEND OUR REQUEST
        performRequest(with: URLString)
    }
    
  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
  {
      let finalURL = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
      
      // CALLING FUNCTION TO SEND OUR REQUEST
      performRequest(with: finalURL)
  }
  
    func performRequest(with urlString: String)
    {
        // Create a URL
        if let url = URL(string: urlString){
            //Create a Session
            let session = URLSession(configuration: .default)
            
            // Give The Session Task
            let task = session.dataTask(with: url) { (data, response, error) in
                 if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                  }
                       
                if let safeData = data {
                    
                    // DECODING OUR DATA
                    if let weather = self.parseJSON(safeData){
                        
                        // TRANSFERING OUR DATA TO MAIN VIEW CONTROLLER
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // Start The Task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do
        {
           let decodedata = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedata.weather[0].id
            let temp = decodedata.main.temp
            let name = decodedata.name
            print("The Given City Name is :\(name)")
            print("The Temparature in Given City is :\(temp)")
            
            // SENDING OUR DATA TO WEATHER DATA MODEL
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
       
    }
    
}
