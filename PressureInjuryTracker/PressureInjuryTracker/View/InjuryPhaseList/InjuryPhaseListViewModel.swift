//
//  InjuryPhaseListViewModel.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 21.04.2024.
//

import Foundation

class InjuryPhaseListViewModel: ObservableObject {
    
    private let injuryPhaseService = InjuryPhaseService()
    @Published var injuryPhases: [InjuryPhaseDTO] = []
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    func getInjuryPhases(injury: Injury) {
        injuryPhaseService.getInjuryPhases(injury: injury) { result in
            switch result {
            case .success(let injuryPhases):
                DispatchQueue.main.async {
                    self.injuryPhases = injuryPhases
                    print(injuryPhases)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alertMessage = "Failed to fetch injury phases: \(error)"
                    self.showAlert = true
                }
            }
        }
    }
}

