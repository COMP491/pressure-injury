//
//  InjuryRowViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import Foundation

class InjuryRowViewModel: ObservableObject {

    @Published var injuryDataDisplayed = false
    @Published var injury: Injury

    init(injury: Injury) {
        self.injury = injury
    }
    func injuryTapped() {
        injuryDataDisplayed = true
    }
}
