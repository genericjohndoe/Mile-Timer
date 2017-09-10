//
//  ViewController.swift
//  Mile Timer
//
//  Created by joel johnson on 9/10/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var stopPause: UIButton!
    @IBOutlet weak var startResume: UIButton!
    
    let stopwatch = Stopwatch()
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        } else {
            stopwatch.resume()
            isRunning = false
            reset.isEnabled = false
            startResume.isEnabled = false
            stopPause.isEnabled = true
        }
    }
    
    
    @IBAction func StopTimer(_ sender: Any) {
        stopwatch.stop()
        reset.isEnabled = true
        startResume.isEnabled = true
        stopPause.isEnabled = false
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        startResume.setTitle("Start",for: .normal)
        timeLabel.text = "00:00:00.00"
        reset.isEnabled = false
        stopPause.isEnabled = false
        isRunning = false
    }
    
    func updateLabel(_ timer: Timer) {
        if stopwatch.isRunning {
            timeLabel.text = stopwatch.elapsedTimeString
        } else {
            timer.invalidate()
        }
    }
}


