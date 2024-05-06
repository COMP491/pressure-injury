//
//  AppState.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 8.04.2024.
//

import Foundation

enum AppState {
    case testing
    case scanning
    case patientFound(Patient)
    case patientNotFound(String, UUID)
    case loadingBarcode
}
