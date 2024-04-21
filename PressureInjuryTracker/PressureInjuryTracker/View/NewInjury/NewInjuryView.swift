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
                    let injury = Injury(id: nil, region: viewModel.region, location: viewModel.location, date: viewModel.date, injuryPhases: nil)
                    viewModel.addInjury(injury: injury, patient: patient)
                }
                .padding(.horizontal)
                .disabled(!viewModel.isFormValid)
            }
            Spacer()
            
            List {
                DatePicker("Tarih", selection: $viewModel.date, displayedComponents: .date)
                
                Picker("Bölge", selection: $viewModel.region) {
                    ForEach(viewModel.getRegions(), id: \.self) {
                        Text($0.rawValue)
                    }
                }
                
                Picker("Lokasyon", selection: $viewModel.location) {
                    ForEach(viewModel.getLocations(), id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Injury Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
