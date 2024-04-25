//
//  InjuryRowViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import Foundation

class InjuryRowViewModel: ObservableObject {

    @Published var injuryDataDisplayed: Bool? = false
    @Published var injury: Injury
    @Published var patient: Patient

    init(injury: Injury, patient: Patient) {
        self.injury = injury
        self.patient = patient
    }
    func injuryTapped() {
        injuryDataDisplayed = true
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}
