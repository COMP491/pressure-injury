//
//  NewInjuryView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import SwiftUI

struct NewInjuryView: View {
    
    @ObservedObject var viewModel: NewInjuryViewModel
    let patient: Patient
    
    
    init(viewModel: NewInjuryViewModel, patient: Patient) {
        self.viewModel = viewModel
        self.patient = patient
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button("Kaydet") {
                    viewModel.addInjury(patient: patient)
                }
                .padding(.horizontal)
                .disabled(!viewModel.isFormValid)
            }
            Spacer()
            
            List {
                DatePicker("Tarih", selection: $viewModel.date, displayedComponents: .date)
                    .environment(\.locale, Locale.init(identifier: String(Locale.preferredLanguages[0].prefix(2))))
                
                Picker("Bölge", selection: $viewModel.regionName) {
                    ForEach(viewModel.getRegions(), id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Lokasyon", selection: $viewModel.locationName) {
                    ForEach(viewModel.getLocations(), id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Yara Durumu"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Tamam")))
        }
    }
}
