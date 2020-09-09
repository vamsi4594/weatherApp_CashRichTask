//
//  WeatherModel.swift
//  weatherApp_CashRichTask
//
//  Created by Mac on 09/09/20.
//  Copyright © 2020 Vamsi KrishnaT hanikanti. All rights reserved.
//

import Foundation
struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    // ASSIGNING DECIMALS VALUES TO TRING
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    
    // ASSIGNING IMAGES BASED ON ID
    var conditionName: String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
   
}

