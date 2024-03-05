//
//  ImageCaptureViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

class ImageCaptureViewModel: ObservableObject {
    private let patient: Patient
    
    init(patient: Patient) {
        self.patient = patient
    }
    
    // Remove this
    func getBarcode() -> String {
        self.patient.barcode
    }
}
