//
//  ContentView.swift
//  UnitConversions
//
//  Created by Michael Page on 11/8/2022.
//

import SwiftUI

enum ConversionType: String {
    case temperature, length, time, volume
}

let conversionTypeOptions: [String: ConversionType] = [
    "length": .length,
    "temperature": .temperature,
    "time": .time,
    "volume": .volume
]

let lengthUnits: [String: UnitLength] = [
    "meters": .meters,
    "kilometers": .kilometers,
    "feet": .feet,
    "yards": .yards,
    "miles": .miles
]

let temperatureUnits: [String: UnitTemperature] = [
    "celsius": .celsius,
    "fahrenheit": .fahrenheit,
    "kelvin": .kelvin
]

let timeUnits: [String: UnitDuration] = [
    "seconds": .seconds,
    "minutes": .minutes,
    "hours": .hours
]

let volumeUnits: [String: UnitVolume] = [
    "milliliters": .milliliters,
    "liters": .liters,
    "cups": .cups,
    "pints": .pints,
    "gallons": .gallons
]

struct ContentView: View {
    @State private var inputAmount = 0.0
    @State private var conversionSelected = "length"
    @State private var inputUnitSelected = "meters"
    @State private var outputUnitSelected = "meters"
    @FocusState private var amountIsFocused: Bool
    
    var selectedConversionType: ConversionType? {
        return conversionTypeOptions[conversionSelected]
    }
    
    var convertedUnitAmount: Double? {
        var inputUnit: Dimension?
        var outputUnit: Dimension?

        switch selectedConversionType {
        case .length:
            inputUnit = lengthUnits[inputUnitSelected]
            outputUnit = lengthUnits[outputUnitSelected]
        case .temperature:
            inputUnit = temperatureUnits[inputUnitSelected]
            outputUnit = temperatureUnits[outputUnitSelected]
        case .time:
            inputUnit = timeUnits[inputUnitSelected]
            outputUnit = timeUnits[outputUnitSelected]
        case .volume:
            inputUnit = volumeUnits[inputUnitSelected]
            outputUnit = volumeUnits[outputUnitSelected]
        default:
            return nil
        }
        
        guard let inputUnit = inputUnit,
              let outputUnit = outputUnit else {
            return nil
        }

        let inputMeasurement = Measurement(value: inputAmount, unit: inputUnit)
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)

        return outputMeasurement.value
    }
    
    var conversionUnitOptions: [String]? {
        switch selectedConversionType {
        case .length:
            return Array(lengthUnits.keys)
        case .temperature:
            return Array(temperatureUnits.keys)
        case .time:
            return Array(timeUnits.keys)
        case .volume:
            return Array(volumeUnits.keys)
        default:
            return nil
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Unit", selection: $conversionSelected) {
                        ForEach(Array(conversionTypeOptions.keys.enumerated()), id: \.element) { _, key in
                            Text(key)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Unit")
                }

                Section {
                    TextField("Amount", value: $inputAmount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Source unit", selection: $inputUnitSelected) {
                        ForEach(conversionUnitOptions ?? [], id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("From")
                }
                
                Section {
                    Text(convertedUnitAmount?.formatted() ?? "")
                    Picker("Target unit", selection: $outputUnitSelected) {
                        ForEach(conversionUnitOptions ?? [], id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("To")
                }
            }
            .navigationTitle("UnitConversions")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
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
