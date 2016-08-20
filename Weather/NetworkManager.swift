//
//  NetworkManager.swift
//  Weather
//
//  Created by David Lashkhi on 20/08/16.
//  Copyright © 2016 David Lashkhi. All rights reserved.
//

import Foundation

class NetworkManager {
    
    func fetchWeatherFromURL(urlSting:String ,success: Dictionary<String, AnyObject> -> (), failure: NSError -> ()) {
        let url = NSURL(string: urlSting)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url) {
            data, response, error in
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                success(json! as! Dictionary<String, AnyObject>)
            }

        }
        task.resume()
    }
}
