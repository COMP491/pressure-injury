//
//  NewInjuryViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

class NewInjuryViewModel: ObservableObject {
    
    @Published var date = Date()
    @Published var region: InjuryRegion = .Ear
    @Published var location: InjuryLocation = .Right
    @Published var alertMessage = ""
    @Published var showAlert = false
    private let injuryService = InjuryService()
    
    
    func addInjury(injury: Injury, patient: Patient) {
        injuryService.addInjury(injury: injury, for: patient) { result in
            switch result {
            case .success(let message):
                self.alertMessage = message
                self.showAlert = true
            case .failure(let error):
                self.alertMessage = "Failed to add injury: \(error)"
                self.showAlert = true
            }
        }
    }
    
    var isFormValid: Bool {
            
            //return region != .Ear && location != .Right
        return true
        }
    
    func getRegions() -> [InjuryRegion] {
        InjuryRegion.allCases
    }
    
    func getLocations() -> [InjuryLocation] {
        InjuryLocation.allCases
    }
}
