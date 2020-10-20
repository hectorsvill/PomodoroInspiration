//
//  PomodoroTimerView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/8/20.
//

import SwiftUI

fileprivate let bottomTopSpacer: CGFloat = 50
fileprivate let soundName = "Hero"

struct PomodoroTimerView: View {
    @ObservedObject var timerSetup = TimerSetup()
    @State private var timerState: TimerState = .notStarted
    @State private var timerType: TimerType = .workTimer
    @State private var startButtonTitle = "Start"

    // Alert
    @State private var alertIspresented = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    // Sound
    let sound = NSSound(named: soundName)
    
    // TimerSetupView
    @State private var isPresentingTimerSetupView = true
    
    // Timer
    @State private var timer: Timer! = nil
    @State private var circleTimer: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
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
                
                TimerView(timerType: $timerType, circleTimer: $circleTimer, timerTitle: $timerSetup.timerTitle)
                    .frame(width: 400, height: 400, alignment: .center)

                Spacer(minLength: bottomTopSpacer)
                
                HStack(spacing: 50) {
                    
                    Button(action: cancelButtonClicked) {
                        Text("Cancel")
                            .foregroundColor(timerState == .notStarted ? .gray : .orange)
                    }
                    .disabled(timerState == .notStarted)
                    .padding(30)
                    
                    Button(action: startButtonClicked){
                        Text(startButtonTitle)
                            .foregroundColor(getForegroundColor())
                    }
                    .padding(30)
                    
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
        .sheet(isPresented: $isPresentingTimerSetupView) {
            TimerSetupView(timerSetup: timerSetup)
        }
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
        timerSetup.timerCountInSeconds = timerSetup.workMinutes
        timerSetup.fetchTimerTitle()
        timerState = .notStarted
        startButtonTitle = "Start"
        isPresentingTimerSetupView.toggle()
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
            timerSetup.timerCountInSeconds -= 1
            circleTimer += CGFloat(1.0 / (timerType == .breakTimer ? CGFloat(timerSetup.breakMinutes) : CGFloat(timerSetup.workMinutes)))
            
            timerSetup.fetchTimerTitle()
            
            if timerSetup.timerCountInSeconds == 0  {
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
        timerSetup.setupBreakTimer()
        timerSetup.fetchTimerTitle()
        startTimer()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
    }
}
