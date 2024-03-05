//
//  ImageCaptureView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import SwiftUI

struct ImageCaptureView: View {
    
    @ObservedObject var viewModel: ImageCaptureViewModel
    
    init(viewModel: ImageCaptureViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(viewModel.getBarcode())
    }
}

#Preview {
    ImageCaptureView(viewModel: ImageCaptureViewModel(patient: Patient(barcode: "testBarcode")))
}
