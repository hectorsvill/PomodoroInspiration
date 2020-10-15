//
//  TimerView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/15/20.
//

import SwiftUI

struct TimerView: View {
    @Binding var timerType: TimerType
    @Binding var circleTimer: CGFloat
    @Binding var timerTitle: String
    
    var body: some View {
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
                    timerType == .breakTimer ? Color.blue : .red,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .frame(width: 400, height: 400)
                .rotationEffect(.init(degrees: -90))
                .animation(.easeOut)
            
            
            Text(timerTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Color.red)
                .font(.system(size: 100, weight: .heavy, design: .default))
        }
        
    }
}
