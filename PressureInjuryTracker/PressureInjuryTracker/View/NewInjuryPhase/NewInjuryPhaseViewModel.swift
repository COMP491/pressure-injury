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
    @Published var length = ""
    @Published var notes = ""
    @Published var conditionsState: [Bool]
    private let conditionCount: Int
    private let degrees = ["Seçiniz", "1", "2", "3", "4"]
    private let injuryPhaseService = InjuryPhaseService()
    let injury: Injury
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var uploading = false
    
    var conditionsTicked: [Bool] {
            conditionsState
        }
    
    init(injury: Injury) {
        self.injury = injury
        self.conditionCount = Conditions.conditionCount()
        self.conditionsState = Array(repeating: false, count: conditionCount)
    }
    
    func saveInjuryPhase(withImage image: UIImage?, drawingData: Data?, injuryPhase: InjuryPhase) {
        self.uploading = true
        injuryPhaseService.saveInjuryPhase(withImage: image, drawingData: drawingData, injuryPhase: injuryPhase) { result in
            switch result {
            case .success(let message):
                self.alertMessage = "Yara eklendi."
                self.showAlert = true
                self.uploading = false
            case .failure(let error):
                self.alertMessage = "Bir sıkıntı oluştu: \(error)"
                self.showAlert = true
            }
        }
    }
    
    
    
    func getDegrees() -> [String] {
        self.degrees
    }
    
    func getConditionsNames(index: Int) -> String {
        Conditions.displayText(forIndex: index) ?? "Diğer"
    }
    
    func getConditionsNames() -> [String] {
        Conditions.allDisplayTexts()
    }
    
    func getConditionCount() -> Int {
        self.conditionCount
    }
}
