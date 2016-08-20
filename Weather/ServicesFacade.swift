//
//  ServicesFacade.swift
//  Weather
//
//  Created by David Lashkhi on 20/08/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

import Foundation

class ServicesFacade {
    
    private let networkManager = NetworkManager()
    private var citiesWeather: [Weather] = Array()
    

    func startFetchingWeather(lat: Double, lon: Double, success: [Weather] -> (), failure: NSError -> ()) {
        let downloadGroup = dispatch_group_create()
        dispatch_group_enter(downloadGroup)
        fetchCitiesWeather({ (weatherOfCities: [Weather]) in
            dispatch_group_leave(downloadGroup)
            }, failure: failure)
        dispatch_group_enter(downloadGroup)
        fetchCurrentLocationWeather(lat, lon: lon, success: { (weatherOfCurrentLocation:[Weather]) in
            dispatch_group_leave(downloadGroup)
            }, failure: failure)
        
        dispatch_group_notify(downloadGroup, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            success(self.citiesWeather)
        }
    }
    
    private func fetchCurrentLocationWeather(lat: Double, lon: Double, success: [Weather] -> (), failure: NSError -> ()) {
        let urlString = Constants.mainURL + "weather?lat=\(lat)&lon=\(lon)"+Constants.apiKey
        networkManager.fetchWeatherFromURL(urlString, success: { (weatherData:Dictionary<String, AnyObject>) in
            guard let main = weatherData[Constants.mainField] as? [String: AnyObject],
                let temp = main[Constants.tempField] as? Double,
                let city = weatherData[Constants.nameField] as? String
            else {
                return;
                
            }
            let weather = Weather(temp: temp, city: city)
            self.citiesWeather.append(weather)
            success(self.citiesWeather)
            }, failure: failure)
    }
    
    private func fetchCitiesWeather(success: [Weather] -> (), failure: NSError -> ()) {
        let urlSting = Constants.mainURL + "group?id=\(Cities.Berlin),\(Cities.London),\(Cities.NewYork),\(Cities.Moscow),\(Cities.Tokyo)&units=metric" + Constants.apiKey
        networkManager.fetchWeatherFromURL(urlSting, success: { (weatherData: Dictionary<String, AnyObject>) in
            guard let citiesArray = weatherData["list"] as? [Dictionary<String, AnyObject>]
                else { return }
            for city in citiesArray {
                guard let main = city[Constants.mainField] as? Dictionary<String, AnyObject>,
                    let temp = main[Constants.tempField] as? Double,
                    let city = city[Constants.nameField] as? String

                    else { return }
                let weather = Weather(temp: temp, city: city)
                self.citiesWeather.append(weather)
            }
            success(self.citiesWeather)
            }, failure: failure)
    }
    
}
