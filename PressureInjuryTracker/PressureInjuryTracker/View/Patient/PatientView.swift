//
//  PatientView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import SwiftUI

struct PatientView: View {
    
    @ObservedObject var viewModel: PatientViewModel
    
    init(viewModel: PatientViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Bilgi 1")
            Text("Bilgi 2")
            Text("Bilgi 3")
            
            Spacer()
            
            HStack {
                Button("Yaralar"){
                    
                }
                .padding(32)
                
                Spacer()
                
                NavigationLink("Yeni Yara", destination: ImageCaptureView(viewModel: ImageCaptureViewModel(patient: viewModel.patient)))
                .padding(32)
            }
        }
        .navigationTitle(viewModel.getBarcode())
    }
}

#Preview {
    PatientView(viewModel: PatientViewModel(patient: Patient(barcode: "testBarcode")))
}
