//
//  ContentView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/8/20.
//

import SwiftUI

enum TimerState {
    case notStarted, startedWork, paused, startedBreak
}

fileprivate let minutes25 = 1500
fileprivate let minutes5 = 300

struct ContentView: View {
    @State private var timerState: TimerState = .notStarted
    @State private var startButtonTitle = "Start"
    @State private var timerTitle = "25:00"
    @State private var isBreakTimer = false
    // Timer
    @State var timerCountInSeconds = minutes25
    @State var timer: Timer! = nil
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Text(timerTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(getTimerTitleForegroundColor())
                    .font(.largeTitle)
                
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        cancelButtonPressed()
                    }
                    .disabled(timerState == .notStarted)
                    .font(.headline)
                    .foregroundColor(timerState == .notStarted ? .gray : .orange)
                    
                    
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
    
    private func getTimerTitleForegroundColor() -> Color{
        switch timerState {
        case .notStarted:
            return .white
        case .paused:
            return .yellow
        case .startedWork:
            return .red
        case .startedBreak:
            return .blue
        }
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
        startButtonTitle = "Start"
        timerTitle = fetchTimerTitle()
    }
    
    private func startButtonTapped() {
        if timerState == .notStarted || timerState == .paused {
            timerState = isBreakTimer ? .startedBreak : .startedWork
            startButtonTitle = "Pause"
            startTimer()
        } else if timerState == .startedWork || timerState == .startedBreak{
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
                if timerState == .startedBreak {
                    isBreakTimer = false
                    resetViews()
                }else {
                    isBreakTimer = true
                    startBreak()
                }
            }
        }
    }

    
    private func startBreak() {
        timerState = .startedBreak
        timerCountInSeconds = minutes5
        timerTitle = fetchTimerTitle()
        startTimer()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
