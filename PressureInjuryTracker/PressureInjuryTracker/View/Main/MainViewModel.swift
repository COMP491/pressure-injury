//
//  MainViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 2.04.2024.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published  var selectedTab = 0
    @Published var patient: Patient
    let exitFunc: () -> Void
    
    init(patient: Patient, exitFunc: @escaping () -> Void) {
        self.patient = patient
        self.exitFunc = exitFunc
    }
}

