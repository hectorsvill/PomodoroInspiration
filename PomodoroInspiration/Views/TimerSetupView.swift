//
//  TimerSetupView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/18/20.
//

import SwiftUI

struct TimerSetupView: View {
    private let workTimerSelection = [25, 35, 45]
    private let breakTimerSelection = [5, 10, 15]
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var timerSetup: TimerSetup
    
    var body: some View {
        VStack {
            Text("Pomodoro Inspiration")
                .fontWeight(.heavy)
                .font(.title)
            
            Spacer(minLength: 50)
            
            Form {
                Picker(selection: $timerSetup.selectedWorkTimer, label: Text("Work Timer:")){
                    ForEach(workTimerSelection, id: \.self) { workTimer in
                        Text("\(workTimer)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Spacer()
                
                Picker(selection: $timerSetup.selectedBreakTimer, label: Text("Break Timer:")){
                    ForEach(breakTimerSelection, id: \.self) { breakTimer in
                        Text("\(breakTimer)")   
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
            }
            
        
            Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .frame(width: 400, height: 200, alignment: .center)
        
    }
}

struct TimerSetupView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSetupView(timerSetup: TimerSetup())
    }
}
