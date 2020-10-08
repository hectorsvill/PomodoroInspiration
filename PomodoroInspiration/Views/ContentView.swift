//
//  ContentView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/8/20.
//

import SwiftUI

enum TimerState {
    case notStarted, started, paused, startedBreak
}

fileprivate let minutes25 = 1500
fileprivate let minutes5 = 300

struct ContentView: View {
    @State private var timerState: TimerState = .notStarted
    @State private var startButtonTitle = "Start"
    @State private var timerTitle = "25:00"
    @State private var cancelButtonIsDiasabled = true
    @State private var isBreakTime = false
    // Timer
    @State var timerCountInSeconds = minutes25 // 25 minutes in seconds
    @State var timer: Timer! = nil
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Text(timerTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(isBreakTime ? .green : .red)
                    .font(.largeTitle)
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        cancelButtonPressed()
                    }
                    .disabled(cancelButtonIsDiasabled)
                    .font(.headline)
                    .foregroundColor(cancelButtonIsDiasabled ? .gray : .orange)
                    
                    
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
        guard timer != nil else { return }
        
        timer.invalidate()
        resetViews()
    }
    
    private func resetViews() {
        timer = nil
        timerCountInSeconds = minutes25
        timerState = .notStarted
        cancelButtonIsDiasabled = true
        isBreakTime = false
        startButtonTitle = "Start"
        timerTitle = fetchTimerTitle()
    }
    
    private func startButtonTapped() {
        cancelButtonIsDiasabled = false
        if timerState == .notStarted || timerState == .paused || timerState == .startedBreak{
            timerState = .started
            startButtonTitle = "Pause"
            startTimer()
        } else if timerState == .started {
            timerState = .paused
            startButtonTitle = "Resume"
            timer.invalidate()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerCountInSeconds -= 1
            
            timerTitle = fetchTimerTitle()
            
            if timerCountInSeconds == 0  {
                timer.invalidate()
                cancelButtonIsDiasabled = true
                if timerState == .startedBreak {
                    resetViews()
                }else {
                    startBreak()
                }
            }
        }
    }

    
    private func startBreak() {
        timerState = .startedBreak
        isBreakTime = true
        timerCountInSeconds = minutes5
        timerTitle = fetchTimerTitle()
        cancelButtonIsDiasabled = false
        startTimer()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
