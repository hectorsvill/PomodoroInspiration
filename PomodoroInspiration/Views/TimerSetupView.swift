//
//  TimerSetupView.swift
//  PomodoroInspiration
//
//  Created by Hector Villasano on 10/18/20.
//

import SwiftUI

struct TimerSetupView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedWorkTimer: Int
    @Binding var selectedBreakTimer: Int
    
    var body: some View {
        VStack {
            Text("Pomodoro Inspiration")
                .fontWeight(.heavy)
                .font(.title)
            
            Spacer(minLength: 50)
            
            Form {
                
                Picker(selection: $selectedWorkTimer, label: Text("Work Timer:")){
                    ForEach(workTimerSelection, id: \.self) { workTimer in
                        Text("\(workTimer)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
                
                Picker(selection: $selectedBreakTimer, label: Text("Break Timer:")){
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
        TimerSetupView(selectedWorkTimer: .constant(1), selectedBreakTimer: .constant(1))
    }
}
