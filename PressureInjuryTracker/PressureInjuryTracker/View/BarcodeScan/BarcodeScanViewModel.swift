//
//  BarcodeScanViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

class BarcodeScanViewModel: ObservableObject {
    @Published var scannedBarcode: String = ""
    @Published var isBarcodeScanned: Bool = false
    @Published var isImageCaptureViewActive: Bool

    init(isImageCaptureViewActive: Bool) {
        self.isImageCaptureViewActive = isImageCaptureViewActive
    }
}
