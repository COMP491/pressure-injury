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
    @State private var gender: String = "Erkek"

    var body: some View {
        Form {
            Section(header: Text("Barkod")) {
                TextField("Barkod", text: .constant(barcode))
                    .disabled(true)
                    .foregroundColor(.gray)
            }
            Section(header: Text("Hasta Bilgileri")) {
                TextField("İsim", text: $name)
                Picker("Soyisim", selection: $gender) {
                    Text("Erkek").tag("Erkek")
                    Text("Kadın").tag("Kadın")
                }
                .pickerStyle(SegmentedPickerStyle())
                Picker("Yaş", selection: $age) {
                    ForEach(0..<121) { age in
                        Text("\(age)").tag(age)
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            
            if name != "" {
                Button(action: {
                    let newPatient = Patient(barcode: barcode, name: name, gender: gender, age: age, injuries: nil)
                    viewModel.addPatient(newPatient)
                }) {
                    Text("Hasta Ekle")
                }
            } else {
                Text("Tüm bilgileri doldurun.")
                    .foregroundStyle(.gray)
                    .opacity(0.8)
            }

        }
        .navigationTitle("Yeni Hasta")
    }
}



