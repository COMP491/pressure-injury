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
                NavigationLink(
                    destination: ImageCaptureView(viewModel: ImageCaptureViewModel(patient: viewModel.getPatient())),
                    isActive: $viewModel.isImageCaptureViewActive
                ) {
                    EmptyView()
                }
                BarcodeScanView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    StartView()
}
