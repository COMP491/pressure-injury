//
//  InjuryListViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import Foundation

class InjuryListViewModel: ObservableObject {

    @Published var isLoadingList = true
    @Published var injuryList: [Injury] = []
    @Published var patient: Patient
    private let injuryService = InjuryService()
    
    
    init(patient: Patient) {
        self.patient = patient
    }
    
    func loadInjuryList(patient: Patient) {
            // Check if injuryList is already loaded
        guard injuryList.isEmpty else { return }

        isLoadingList = true
        injuryService.fetchInjuries(patient: patient) { result in
            switch result {
            case .success(let injuries):
                DispatchQueue.main.async {
                    self.injuryList = injuries
                    self.isLoadingList = false
                }
            case .failure(let error):
                print("Failed to load injury list: \(error)")
                self.isLoadingList = false
            }
        }
    }
}

