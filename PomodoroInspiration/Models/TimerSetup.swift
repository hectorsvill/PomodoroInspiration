//
//  TimerSetup.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/18/20.
//

import Foundation

class TimerSetup: ObservableObject {
    var workMinutes = 1500
    var breakMinutes = 300
    
    @Published var timerTitle = "25:00"
    @Published var timerCountInSeconds = 1500
    
    @Published var selectedWorkTimer = 25 {
        didSet {
            setupWorkTimer()
        }
    }
    
    @Published var selectedBreakTimer = 5
    
    func setupWorkTimer() {
        workMinutes = selectedWorkTimer * 60
        timerCountInSeconds = workMinutes
        fetchTimerTitle()
    }
    
    func setupBreakTimer() {
        breakMinutes = selectedBreakTimer * 60
        timerCountInSeconds = breakMinutes
    }
    
    func fetchTimerTitle() {
        let minutes = timerCountInSeconds / 60
        let seconds = timerCountInSeconds % 60
        
        let minutesString = "\(minutes < 10 ? "0" : "")\(minutes)"
        let secondsString = "\(seconds < 10 ? "0" : "")\(seconds)"
        
        timerTitle = "\(minutesString):\(secondsString)"
    }
}
