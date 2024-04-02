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
        injuryList.append(Injury(region: "Sırt", grade: "1"))
        injuryList.append(Injury(region: "Sağ bacak", grade: "4"))
        injuryList.append(Injury(region: "Sol bacak", grade: "İyi"))
        injuryList.append(Injury(region: "Kalça", grade: "Kötü"))
        
        isLoadingList = false
    }
}

