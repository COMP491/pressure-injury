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
        NavigationStack {
            switch viewModel.state {
            case .scanning:
                BarcodeScanView(viewModel: viewModel)
            case .patientFound(let patient):
                MainView(viewModel: MainViewModel(patient: patient, exitFunc: viewModel.logout))
            case .patientNotFound(let barcode, _):
                NewPatientView(barcode: barcode).environmentObject(viewModel)
            case .testing:
                MainView(viewModel: MainViewModel(patient: Patient(barcode: "114123124", name: "Testing", gender: "Erkek", age: 236, injuries: nil), exitFunc: viewModel.logout))
            }
        }
    }
}



