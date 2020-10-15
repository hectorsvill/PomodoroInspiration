//
//  ContentView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/8/20.
//

import SwiftUI

fileprivate let minutes25 = 1500
fileprivate let minutes5 = 300
fileprivate let bottomTopSpacer: CGFloat = 50
fileprivate let soundName = "Hero"

struct ContentView: View {
    @State private var timerState: TimerState = .notStarted
    @State private var timerType: TimerType = .workTimer
    @State private var startButtonTitle = "Start"
    @State private var timerTitle = "25:00"
    // Timer
    @State private var timerCountInSeconds = minutes25
    @State private var timer: Timer! = nil
    @State private var circleTimer: CGFloat = 0
    // Alert
    @State private var alertIspresented = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    // Sound
    let sound = NSSound(named: soundName)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            VStack {
                Spacer(minLength: bottomTopSpacer)
                
                Text(timerType.rawValue)
                    .frame(width: 50, height: 50, alignment: .center)
                    .font(.system(size: 18, weight: .light, design: .default))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                Spacer(minLength: bottomTopSpacer)
                
                TimerView(timerType: $timerType, circleTimer: $circleTimer, timerTitle: $timerTitle)
                    .frame(width: 400, height: 400, alignment: .center)

                Spacer(minLength: bottomTopSpacer)
                
                HStack(spacing: 50) {
                    
                    Button(action: cancelButtonClicked) {
                        Text("Cancel")
                            .foregroundColor(timerState == .notStarted ? .gray : .orange)
                    }
                    .disabled(timerState == .notStarted)
                    .padding(30)
                    .shadow(radius: 5)
                    .background(Color.white)
                    
                    Button(action: startButtonClicked){
                        Text(startButtonTitle)
                            .foregroundColor(getForegroundColor())
                    }
                    .padding(30)
                    .background(Color.white)
                    .shadow(radius: 5)
                    
                }
                
                Spacer(minLength: bottomTopSpacer)
            }
        }
        .alert(isPresented: $alertIspresented) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text(timerType == .workTimer ? "Continue" : "OK"))  {
                sound?.stop()
                if timerType == .breakTimer {
                    timerType = .workTimer
                    resetViews()
                }else if timerType == .workTimer {
                    timerType = .breakTimer
                    startBreak()
                }
            })
        }
    }
    
    private func fetchTimerTitle() -> String {
        let minutes = timerCountInSeconds / 60
        let seconds = timerCountInSeconds % 60
        
        let minutesString = "\(minutes < 10 ? "0" : "")\(minutes)"
        let secondsString = "\(seconds < 10 ? "0" : "")\(seconds)"
        
        return "\(minutesString):\(secondsString)"
    }
    
    private func getForegroundColor() -> Color {
        switch timerState {
        case .notStarted:
            return .green
        case .paused:
            return .yellow
        case .started:
            return timerType == .workTimer ? .red : .blue
        }
    }
    
    private func cancelButtonClicked() {
        guard timer != nil else { return }
        
        timer.invalidate()
        resetViews()
    }
    
    private func resetViews() {
        timer = nil
        circleTimer = 0.0
        timerCountInSeconds = minutes25
        timerState = .notStarted
        startButtonTitle = "Start"
        timerTitle = fetchTimerTitle()
    }
    
    private func startButtonClicked() {
        if timerState == .notStarted || timerState == .paused {
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
            circleTimer += CGFloat(1.0 / (timerType == .breakTimer ? CGFloat(minutes5) : CGFloat(minutes25)))
            
            timerTitle = fetchTimerTitle()
            
            if timerCountInSeconds == 0  {
                timer.invalidate()
                timerCompleted()
            }
        }
    }
    
    private func timerCompleted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sound?.play()
            if timerType == .breakTimer {
                alertTitle = "Great Work"
                alertMessage = "Click Start to continue the Pomodoro Technique"
            }else if timerType == .workTimer {
                alertTitle = "Break Time"
                alertMessage = "Click Continue to start break"
            }
            
            alertIspresented = true
        }
    }
    
    private func startBreak() {
        timerState = .started
        circleTimer = 0.0
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
