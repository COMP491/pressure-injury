//
//  NewInjuryPhaseViewModel.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 20.04.2024.
//

import Foundation
import UIKit

class NewInjuryPhaseViewModel: ObservableObject {
    
    @Published var showCamera: Bool = false
    @Published var imageData: Data?
    @Published var degree = "Seçiniz"
    @Published var width = ""
    @Published var height = ""
    @Published var notes = ""
    @Published var conditionsState: [Bool]
    private let conditionsNames = ["Kemoterapi", "Azalmış mental durum", "Sigara", "Dehidrasyon", "Hareket kısıtlılığı", "Sürtünme", "Diyabet", "Cerrahi girişim", "Dolaşım bozukluğu", "Yatağa bağımlılık", "Nem", "Basınç"]
    private let conditionCount: Int
    private let degrees = ["Seçiniz", "1", "2", "3", "4"]
    private let injuryPhaseService = InjuryPhaseService()
    let injury: Injury
    @Published var alertMessage = ""
    @Published var showAlert = false
    var conditionsTicked: [Bool] {
            conditionsState
        }
    
    init(injury: Injury) {
        self.injury = injury
        self.conditionCount = conditionsNames.count
        self.conditionsState = Array(repeating: false, count: conditionCount)
    }
    
    func saveInjuryPhase(withImage image: UIImage?, injuryPhase: InjuryPhase) {
        injuryPhaseService.saveInjuryPhase(withImage: image, injuryPhase: injuryPhase) { result in
            switch result {
            case .success(let message):
                self.alertMessage = message
                self.showAlert = true
            case .failure(let error):
                self.alertMessage = "Failed to add injury phase: \(error)"
                self.showAlert = true
            }
        }
    }
    
    
    
    func getDegrees() -> [String] {
        self.degrees
    }
    
    func getConditionsNames(index: Int) -> String {
        self.conditionsNames[index]
    }
    
    func getConditionsNames() -> [String] {
        self.conditionsNames
    }
    
    func getConditionCount() -> Int {
        self.conditionCount
    }
}
