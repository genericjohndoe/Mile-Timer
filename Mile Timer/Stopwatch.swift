//
//  Stopwatch.swift
//  Mile Timer
//
//  Created by joel johnson on 9/10/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import Foundation

class Stopwatch {
    
    private var startTime: Date?
    private var timeAtPause: TimeInterval = 0.0
    
    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return -startTime.timeIntervalSinceNow
        } else {
            return 0
        }
    }
    
    var elapsedTimeString: String {
        return String(format: "%02d:%02d:%02d.%02d", Int(elapsedTime/3600), Int(elapsedTime / 60),Int(elapsedTime.truncatingRemainder(dividingBy: 60)), Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100)))
    }
    
    var isRunning: Bool {
        return startTime != nil
    }
    
    func start() {
        startTime = Date()
        print("start called")
    }
    
    func stop() {
        timeAtPause = elapsedTime
        startTime = nil
    }
    
    func resume() {
        startTime = Date() - timeAtPause
        print("resume called")
    }
    
}

