//
//  CurrentLocationService.swift
//  Weather
//
//  Created by David Lashkhi on 20/08/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentLocationService:NSObject, CLLocationManagerDelegate {
    
    var myLocation: CLLocationCoordinate2D?
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locationManager.location!.coordinate
        print("locations = \(myLocation!.latitude) \(myLocation!.longitude)")
        locationManager.stopUpdatingLocation()
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.currentLocationUpdatedNotification, object: nil)
    }
}