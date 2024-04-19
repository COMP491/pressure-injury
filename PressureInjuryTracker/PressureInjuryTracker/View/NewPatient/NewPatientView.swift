//
//  NewPatientView.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 31.03.2024.
//

import SwiftUI

struct NewPatientView: View {
    @EnvironmentObject var viewModel: StartViewModel
    var barcode: String
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var gender: String = "Male"

    var body: some View {
        Form {
            Section(header: Text("Barcode")) {
                TextField("Barcode", text: .constant(barcode))
                    .disabled(true)
                    .foregroundColor(.gray)
            }
            Section(header: Text("Patient Details")) {
                TextField("Name", text: $name)
                Picker("Gender", selection: $gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
                .pickerStyle(SegmentedPickerStyle())
                Picker("Age", selection: $age) {
                    ForEach(0..<121) { age in
                        Text("\(age)").tag(age)
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            Button(action: {
                let newPatient = Patient(barcode: barcode, name: name, gender: gender, age: age, injuries: nil)
                viewModel.addPatient(newPatient)
            }) {
                Text("Add Patient")
            }
        }
        .navigationTitle("New Patient")
    }
}



