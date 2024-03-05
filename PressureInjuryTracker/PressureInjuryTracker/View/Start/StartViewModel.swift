//
//  StartViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

class StartViewModel: ObservableObject {
    @Published var isImageCaptureViewActive: Bool = false
    @Published var scannedBarcode: String = ""
    @Published var isBarcodeScanned: Bool = false    
    private var patient: Patient?
    
    func saveBarcode(barcode: String) {
        scannedBarcode = barcode
        isBarcodeScanned = true
        isImageCaptureViewActive = true
        patient = Patient(barcode: barcode)
    }
    
    func getPatient() -> Patient {
        if let patient = self.patient {
            return patient
        } else {
            return Patient(barcode: "error")
        }
    }
}
