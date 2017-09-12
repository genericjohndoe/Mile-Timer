//
//  WeatherNetworking.swift
//  Mile Timer
//
//  Created by joel johnson on 9/12/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherNetworking {
    static let shared = WeatherNetworking()
    
    func getWeatherData(coordinates: CLLocationCoordinate2D, completion: @escaping (_ success: Bool, _ error: String, _ temps: String) -> Void){
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast/daily"
        components.queryItems = [URLQueryItem]()
        
        components.queryItems?.append(URLQueryItem(name: "lat", value: "\(coordinates.latitude)"))
        components.queryItems?.append(URLQueryItem(name: "lon", value: "\(coordinates.longitude)"))
        components.queryItems?.append(URLQueryItem(name: "mode", value: "json"))
        components.queryItems?.append(URLQueryItem(name: "units", value: "metric"))
        components.queryItems?.append(URLQueryItem(name: "cnt", value: "1"))
        components.queryItems?.append(URLQueryItem(name: "APPID", value: "156132b426eb2ace363facf49fa70c01"))
        
        //print(components.url!)
        
        let request = NSMutableURLRequest(url: components.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest){ data, response, error in
            
            guard error == nil else {
                completion(false, "error", "")
                print("error")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false, "Your request returned a status code other than 2xx", "")
                print("Your request returned a status code other than 2xx")
                return
            }
            
            guard let data = data else {
                completion(false, "No data was returned by the request", "")
                print("No data was returned by the request")
                return
            }
            
            do {
                //print("data description \(data.description)")
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
//                for k in parsedResult.keys{
//                    print(k)
//                }
                //print(parsedResult)
                let list = parsedResult["list"] as! NSArray
                let dictionary = list[0] as! NSDictionary
                let temps = dictionary["temp"]! as! [String: Any]
                //print(temps)
                let high = temps["max"]!
                let low = temps["min"]!
                completion(true,"","\(high)/\(low)")
                //print("\(high)/\(low)")
                return
            } catch {
                completion(false, "Could not parse the data as JSON", "")
                print("Could not parse the data as JSON")
                return
            }
            
        }
        task.resume()
        return
    }
}
