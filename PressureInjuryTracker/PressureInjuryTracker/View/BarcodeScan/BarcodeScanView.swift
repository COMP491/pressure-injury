//
//  BarcodeScanView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import SwiftUI

struct BarcodeScanView: View {
    @ObservedObject var viewModel: StartViewModel
    
    var body: some View {
        VStack {
            Text("Barkodu Tarayın")
            Button(action: {
                // Simulating scanning barcode, replace this with actual barcode scanning logic
                viewModel.saveBarcode(barcode: "ScannedBarcode123")
            }) {
                Text("Tara!")
            }
        }
        .padding()
    }
}

#Preview {
    BarcodeScanView(viewModel: StartViewModel())
}
