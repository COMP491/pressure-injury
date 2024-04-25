//
//  StartViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

class StartViewModel: ObservableObject {
    @Published var state: AppState = .scanning
    @Published var navigateToPatientView: Bool = false
    @Published var navigateToNewPatientView: Bool = false
    private let patientService = PatientService()
    
    func logout() -> Void {
        self.state = .scanning
    }

    func saveBarcode(barcode: String) {
        patientService.getPatientDetails(barcode: barcode) { result in
            switch result {
            case .success(let patient):
                DispatchQueue.main.async {
                    self.state = .patientFound(patient)
                    self.navigateToPatientView = true
                }
            case .failure:
                DispatchQueue.main.async {
                    self.state = .patientNotFound(barcode, UUID())
                    self.navigateToNewPatientView = true
                }
            }
        }
    }

    func addPatient(_ patient: Patient) {
        patientService.addPatient(patient) { result in
            switch result {
            case .success(let message):
                print("Hasta eklendi: \(message)")
                DispatchQueue.main.async {
                    self.state = .patientFound(patient)
                }
            case .failure(let error):
                print("Hasta eklenemedi: \(error)")
            }
        }
    }
}


