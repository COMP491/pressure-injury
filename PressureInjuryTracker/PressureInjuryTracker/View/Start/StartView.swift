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

        if viewModel.isBarcodeScanned {
            MainView(viewModel: MainViewModel(patient: viewModel.getPatient(), exitFunc: viewModel.logout))
        } else {
            BarcodeScanView(viewModel: viewModel)
        }
    }
}

#Preview {
    StartView()
}
