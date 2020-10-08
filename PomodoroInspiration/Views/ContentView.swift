//
//  ContentView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/8/20.
//

import SwiftUI

enum TimerState {
    case notStarted, started, paused, resumed, finished
}

fileprivate let minutes25 = 1500

struct ContentView: View {
    @State private var timerState: TimerState = .notStarted
    @State private var startButtonTitle = "Start"
    @State private var timerTitle = "25:00"
    @State private var cancelButtonIsDiasabled = true
    // Timer
    @State var timerCountInSeconds = minutes25 // 25 minutes in seconds
    @State var timer: Timer! = nil
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottom)
            VStack {
                Text(timerTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.red)
                    .font(.largeTitle)
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        cancelButtonPressed()
                    }
                    .disabled(cancelButtonIsDiasabled)
                    .font(.headline)
                    .foregroundColor(.gray)
                    
                    
                    Button(startButtonTitle) {
                        startButtonTapped()
                    }
                    .font(.headline)
                    .foregroundColor(.green)
                    
                    Spacer()
                }
            }
        }
    }
    
    private func fetchTimerTitle() -> String {
        let minutes = timerCountInSeconds / 60
        let seconds = timerCountInSeconds % 60
        
        let minutesString = "\(minutes < 10 ? "0" : "")\(minutes)"
        let secondsString = "\(seconds < 10 ? "0" : "")\(seconds)"
        
        
        return "\(minutesString):\(secondsString)"
    }
    
    private func cancelButtonPressed() {
        guard timer != nil else {
            return
        }
        
        timer.invalidate()
        timer = nil
        timerCountInSeconds = minutes25
        timerState = .notStarted
        cancelButtonIsDiasabled = true
        startButtonTitle = "Start"
        timerTitle = fetchTimerTitle()
        
    }
    
    private func startButtonTapped() {
        cancelButtonIsDiasabled = false
        if timerState == .notStarted || timerState == .paused {
            timerState = .started
            startButtonTitle = "Pause"
            startTimer()
        } else if timerState == .started {
            timerState = .paused
            startButtonTitle = "Resume"
            timer.invalidate()
        } else if timerState == .finished {
            // start 5 minute break timer
            
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerCountInSeconds -= 1
            
            timerTitle = fetchTimerTitle()
            
            if timerCountInSeconds == 0 {
                timer.invalidate()
                timerState = .finished
            }
        }
        
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
