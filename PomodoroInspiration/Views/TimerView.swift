//
//  TimerView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/15/20.
//

import SwiftUI

struct TimerView: View {
    private let strokeStyleLineWidth: CGFloat = 10
    @Binding var timerType: TimerType
    @Binding var circleTimer: CGFloat
    @Binding var timerTitle: String
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(
                    Color.gray.opacity(0.10),
                    style: StrokeStyle(lineWidth: strokeStyleLineWidth, lineCap: .round)
                )
            
            Circle()
                .trim(from: 0, to: circleTimer)
                .stroke(
                    fetchTimerColor(),
                    style: StrokeStyle(lineWidth: strokeStyleLineWidth, lineCap: .round)
                )
                .rotationEffect(.init(degrees: -90))
                .animation(.easeOut)
            
            
            Text(timerTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(fetchTimerColor())
                .font(.system(size: 100, weight: .heavy, design: .default))
        }
    }

    func fetchTimerColor() -> Color {
        timerType == .breakTimer ? Color.blue : .red
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerType: .constant(TimerType.workTimer), circleTimer: .constant(0.5), timerTitle: .constant("25:00"))
    }
}
