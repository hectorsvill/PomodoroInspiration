//
//  ContentView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/8/20.
//

import SwiftUI

struct ContentView: View {
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
                    .foregroundColor(.orange)
                    
                    
                    Button(startButtonTitle) {
                        // start or pause timer
                        
                        // if started set to pause
                        startButtonTitle = "Pause"
                        
                        // if Paused set to Resume
                        //startButtonTitle = "Resume"
                        
                        
                        
                    }
                    .font(.headline)
                    .foregroundColor(.green)
                    
                    Spacer()
                }
            }
        }
        
    }
    
    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
