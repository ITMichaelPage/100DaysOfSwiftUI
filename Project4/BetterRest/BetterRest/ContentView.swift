//
//  ContentView.swift
//  BetterRest
//
//  Created by Michael Page on 13/8/2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var bedTime: String? {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hourInSeconds = (components.hour ?? 0) * 60 * 60
            let minuteInSeconds = (components.minute ?? 0) * 60
            
            let predication = try model.prediction(wake: Double(hourInSeconds + minuteInSeconds), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let bedTime = wakeUp - predication.actualSleep
            return bedTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return ""
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("When do you want to wake up?")
                            .font(.headline)
                        
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Daily coffee intake")
                            .font(.headline)
                        
                        Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                            ForEach(1...20, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Label(bedTime ?? "", systemImage: "bed.double.circle.fill")
                            .font(.largeTitle)
                    }
                } header: {
                    Text("Recommended bedtime")
                }
            }
            .navigationTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
