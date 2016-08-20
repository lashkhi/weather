//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by David Lashkhi on 20/08/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    private let locationService = CurrentLocationService()
    private let serviceFacade = ServicesFacade()
    private var weather = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(currentLocationRecievedNotification(_:)), name: Constants.currentLocationUpdatedNotification, object: nil)
    }
    
    @objc func currentLocationRecievedNotification(notification: NSNotification) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            self.serviceFacade.startFetchingWeather((self.locationService.myLocation?.latitude)!, lon: (self.locationService.myLocation?.longitude)!, success: { (weather: [Weather]) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.weather = weather
                    self.tableView.reloadData()
                })
            }) { (NSError) in
                print("loading data error")
            }
        }
        
    }
    
        // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath)
        if  weather.indices.contains(indexPath.row) {
            cell.textLabel?.text = "\(weather[indexPath.row].temp!)"
            cell.detailTextLabel?.text = "\(weather[indexPath.row].city!)"
        } else {
            cell.textLabel?.text = Constants.placeholder
            cell.detailTextLabel?.text = Constants.placeholder
        }
        
        return cell
    }
    

    
    


}
