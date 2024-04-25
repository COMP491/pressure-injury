//
//  NewInjuryViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

class NewInjuryViewModel: ObservableObject {
    
    @Published var date = Date()
    @Published var regionName: String = InjuryRegion.Ear.turkishName
    @Published var locationName: String = InjuryLocation.Right.turkishName
    @Published var alertMessage = ""
    @Published var showAlert = false
    private let injuryService = InjuryService()
    
    
    func addInjury(patient: Patient) {
        let injury = Injury(id: nil, region: InjuryRegion.fromTurkishName(regionName), location: InjuryLocation.fromTurkishName(locationName), date: date, injuryPhases: nil)
        injuryService.addInjury(injury: injury, for: patient) { result in
            switch result {
            case .success(let message):
                self.alertMessage = "Yara başarıyla eklendi."
                self.showAlert = true
            case .failure(let error):
                self.alertMessage = "Yara eklenemedi: \(error)"
                self.showAlert = true
            }
        }
    }
    
    var isFormValid: Bool {
            
            //return region != .Ear && location != .Right
        return true
        }
    
    func getRegions() -> [String] {
        InjuryRegion.allCases.map { $0.turkishName }
    }
    
    func getLocations() -> [String] {
        InjuryLocation.allCases.map { $0.turkishName }
    }
}
