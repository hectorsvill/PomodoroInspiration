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

fileprivate let bottomTopSpacer: CGFloat = 50


struct ContentView: View {
    @State private var timerState: TimerState = .notStarted
    @State private var startButtonTitle = "Start"
    @State private var timerTitle = "25:00"
    @State private var isBreakTimer = false
    // Timer
    @State var timerCountInSeconds = minutes25
    @State var timer: Timer! = nil
    
    @State var circleTimer: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            VStack {
                Spacer(minLength: bottomTopSpacer)
                
                Text(isBreakTimer ? "Break" : "Work")
                    .frame(width: 50, height: 50, alignment: .center)
                    .font(.system(size: 18, weight: .light, design: .default))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                Spacer(minLength: bottomTopSpacer)
                
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(
                            Color.gray.opacity(0.10),
                            style: StrokeStyle(lineWidth: 5, lineCap: .round)
                        )
                        .frame(width: 400, height: 400)
                    
                    Circle()
                        .trim(from: 0, to: circleTimer)
                        .stroke(
                            isBreakTimer ? Color.green : .red,
                            style: StrokeStyle(lineWidth: 5, lineCap: .round)
                        )
                        .frame(width: 400, height: 400)
                        .rotationEffect(.init(degrees: 90))
                    
                    
                    Text(timerTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(getForegroundColor())
                        .font(.system(size: 100, weight: .heavy, design: .default))
                }
                
                Spacer(minLength: bottomTopSpacer)
                
                HStack(spacing: 50) {
                    
                    Button(action: cancelButtonClicked) {
                        Text("Cancel")
                            .foregroundColor(timerState == .notStarted ? .gray : .orange)
                    }
                    .disabled(timerState == .notStarted)
                    .padding(30)
                    .background(
                        Capsule()
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    .shadow(radius: 5)
                    
                    Button(action: startButtonClicked){
                        Text(startButtonTitle)
                            .foregroundColor(getForegroundColor())
                    }
                    .padding(30)
                    .background(
                        Capsule()
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    .shadow(radius: 5)
                    
                }
                
                Spacer(minLength: bottomTopSpacer)
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
    
    private func getForegroundColor() -> Color{
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
    
    private func cancelButtonClicked() {
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
    
    private func startButtonClicked() {
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
            circleTimer += CGFloat(1.0 / (isBreakTimer ? CGFloat(minutes5) : CGFloat(minutes25)))
            
            timerTitle = fetchTimerTitle()
            
            if timerCountInSeconds == 0  {
                timer.invalidate()
                circleTimer = 0.0
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
