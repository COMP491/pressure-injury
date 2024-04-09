//
//  StartView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import SwiftUI

struct StartView: View {
    @StateObject private var viewModel = StartViewModel()

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .scanning:
                    BarcodeScanView(viewModel: viewModel)
                case .patientFound(let patient):
                    PatientView(viewModel: PatientViewModel(patient: patient))
                case .patientNotFound(let barcode, _):
                    NewPatientView(barcode: barcode).environmentObject(viewModel)
                case .testing:
                    PatientView(viewModel: PatientViewModel(patient: Patient(barcode: "114123124", name: "Testing", gender: "Male", age: 236, injuries: nil)))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



