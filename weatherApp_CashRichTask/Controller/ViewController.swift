//
//  ViewController.swift
//  weatherApp_CashRichTask
//
//  Created by Mac on 09/09/20.
//  Copyright © 2020 Vamsi KrishnaT hanikanti. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    // CREATING INSTANCES FOR WEATHER & LOCATION MANAGER
    var weartherManager = WeatherManager()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // ASSIGNING DELEGATE FOR LOCATION MANAGER & REQUESTING LOCATION
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // ASSIGNING DELEGATE FOR WEATHER MANAGER & TEXT FIELD
        weartherManager.delegate = self
        searchTextField.delegate = self
        
    }


}

extension ViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        }else
        {
            textField.placeholder = "Type Something Here"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       if let city = searchTextField.text
       {
        weartherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
       // print(weather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        
    }
    func didFailWithError(error: Error){
        print(error)
    }
}

extension ViewController: CLLocationManagerDelegate {
    @IBAction func locationPressed(_ sendor: UIButton) {
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
       {
           if let location = locations.last
           {
               locationManager.stopUpdatingLocation()
               let lat = location.coordinate.latitude
               let lon = location.coordinate.longitude
               weartherManager.fetchWeather(latitude: lat , longitude : lon)
               
           }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

