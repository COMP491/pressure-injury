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
    
    func loadInjuryList() {
        injuryList.append(Injury(location: "Sırt", registrationDate: "1"))
        injuryList.append(Injury(location: "Sağ bacak", registrationDate: "4"))
        injuryList.append(Injury(location: "Sol bacak", registrationDate: "İyi"))
        injuryList.append(Injury(location: "Kalça", registrationDate: "Kötü"))
        
        isLoadingList = false
    }
}


