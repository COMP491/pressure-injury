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
    
    init(patient: Patient) {
        self.patient = patient
    }
    
    func loadInjuryList() {
        injuryList.append(Injury(location: "Sırt", registrationDate: "1"))
        injuryList.append(Injury(location: "Sağ bacak", registrationDate: "2"))
        injuryList.append(Injury(location: "Sol bacak", registrationDate: "3"))
        injuryList.append(Injury(location: "Kalça", registrationDate: "4"))
        
        isLoadingList = false
    }
}

