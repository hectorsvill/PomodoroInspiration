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

struct ContentView: View {
    @State private var timerState: TimerState = .notStarted
    @State private var startButtonTitle = "Start"
    @State private var timerTitle = "25:00"
    
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
                        //canel timer and reset
                    }
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
    
    private func startButtonTapped() {
        if timerState == .notStarted || timerState == .paused {
            timerState = .started
            startButtonTitle = "Pause"
        } else if timerState == .started {
            timerState = .paused
            startButtonTitle = "Resume"
        } else if timerState == .finished {
            // start 5 minute break timer
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
