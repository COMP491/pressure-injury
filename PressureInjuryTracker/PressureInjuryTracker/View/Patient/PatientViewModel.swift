//
//  PatientViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

class PatientViewModel: ObservableObject {
    
    @Published var patient: Patient
    
    init(patient: Patient) {
        self.patient = patient
    }
    
}

