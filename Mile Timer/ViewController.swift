//
//  ViewController.swift
//  Mile Timer
//
//  Created by joel johnson on 9/10/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var stopPause: UIButton!
    @IBOutlet weak var startResume: UIButton!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var weather: UIBarButtonItem!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let stopwatch = Stopwatch()
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    var isRunning = false
    var locationManager: CLLocationManager = CLLocationManager()
    let path = GMSMutablePath()
    var intervals = 0.0
    var coordinate = CLLocationCoordinate2D()
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        //locationManager.locationServicesEnabled{
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            //updates with change in distance
            locationManager.startUpdatingLocation()
        //}
    }
    
    @IBAction func StartTimer(_ sender: Any) {
        Timer.scheduledTimer(timeInterval: 0.01, target: self,
                             selector: #selector(ViewController.updateLabel(_:)), userInfo: nil, repeats: true)
        if !isRunning{
            stopwatch.start()
            startResume.setTitle("Resume",for: .normal)
            isRunning = true
            stopPause.isEnabled = true
            startResume.isEnabled = false
            save.isEnabled = false
        } else {
            stopwatch.resume()
            isRunning = false
            reset.isEnabled = false
            startResume.isEnabled = false
            stopPause.isEnabled = true
            save.isEnabled = false
        }
    }
    
    @IBAction func StopTimer(_ sender: Any) {
        stopwatch.stop()
        reset.isEnabled = true
        startResume.isEnabled = true
        stopPause.isEnabled = false
        save.isEnabled = true
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        startResume.setTitle("Start",for: .normal)
        timeLabel.text = "00:00:00.00"
        reset.isEnabled = false
        stopPause.isEnabled = false
        isRunning = false
        save.isEnabled = false
    }
    
    func updateLabel(_ timer: Timer) {
        if stopwatch.isRunning {
            timeLabel.text = stopwatch.elapsedTimeString
        } else {
            timer.invalidate()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.count > 0){
            coordinate = locations[0].coordinate
            print(coordinate.latitude)
            print(coordinate.longitude)
            //add new point in polyline
            path.add(coordinate)
            //show polyline
            let polyline = GMSPolyline(path: path)
            polyline.map = map
            //focus map on location
            let location = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 18)
            map.camera = location
            //count number of 10 m inervals
            intervals = intervals + 1
    
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("location error")
    }
    
    @IBAction func getWeatherData(_ sender: UIBarButtonItem) {
        indicator.startAnimating()
        WeatherNetworking.shared.getWeatherData(coordinates: coordinate){
            (success, error, temps) in
            if success{
                DispatchQueue.main.async{
                    sender.title = temps
                    self.indicator.stopAnimating()
                }
            }
            else{
                WeatherNetworking.shared.showErrorOnMain(self, "No weather data can be shown")
                self.indicator.stopAnimating()
            }
        }
    }
    
    @IBAction func saveData(_ sender: Any) {
        let timeArray = timeLabel.text?.components(separatedBy: ":")
        let hours = Double((timeArray?[0])!)!*60
        let minutes = Double((timeArray?[1])!)
        let seconds = Double((timeArray?[2])!)!/60.0
        let numbMinutes = hours + minutes! + seconds
        let numbMiles: Double = self.intervals*0.00621371
        let minmile =  numbMinutes/numbMiles
    //let r = RunningTimes(
        let r = RunningTimes(minpermile:minmile , context: stack.context)
        //let runningtimes = RunningTimes(minpermile: minmile, context: stack.context)
        stack.save()
    }
}


