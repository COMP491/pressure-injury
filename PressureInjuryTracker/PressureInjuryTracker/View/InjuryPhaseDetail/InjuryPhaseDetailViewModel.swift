//
//  InjuryPhaseDetailViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 27.04.2024.
//

import Foundation
import UIKit

class InjuryPhaseDetailViewModel: ObservableObject {
    
    @Published var showCamera: Bool = false
    @Published var imageData: Data?
    @Published var drawingData: Data?
    @Published var degree = "1"
    @Published var width = ""
    @Published var length = ""
    @Published var notes = ""
    @Published var conditionsState: [Bool]
    private let conditionCount: Int
    private let degrees = ["1", "2", "3", "4"]
    private let injuryPhaseService = InjuryPhaseService()
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var uploading = false
    let injury: Injury
    
    var conditionsTicked: [Bool] {
            conditionsState
        }
    let injuryPhase: InjuryPhaseDTO
    
    init(injury: Injury, injuryPhase: InjuryPhaseDTO) {
        self.injury = injury
        self.injuryPhase = injuryPhase
        self.conditionCount = Conditions.conditionCount()
        self.conditionsState = Array(repeating: false, count: conditionCount)
        self.degree = String(format: "%.0f", injuryPhase.degree)
        self.width = String(injuryPhase.width)
        self.length = String(injuryPhase.length)
        self.notes = injuryPhase.notes ?? ""
        self.conditionsState = injuryPhase.conditionsTicked
        self.imageData = injuryPhase.image
        self.drawingData = injuryPhase.drawingData
    }
    
    func editInjuryPhase(drawingData: Data?, injuryPhase: InjuryPhase) {
        self.uploading = true
        injuryPhaseService.editInjuryPhase(drawingData: drawingData, injuryPhase: injuryPhase) { result in
            switch result {
            case .success:
                self.alertMessage = "Yara güncellendi."
                self.showAlert = true
                self.uploading = false
            case .failure(let error):
                self.alertMessage = "Bir sıkıntı oluştu: \(error)"
                self.showAlert = true
            }
        }
    }
    
    func deleteInjuryPhase(injuryPhase: InjuryPhaseDTO) {
        self.uploading = true
        injuryPhaseService.deleteInjuryPhase(injuryPhase: injuryPhase) { result in
            switch result {
            case .success:
                self.alertMessage = "Yara fazı başarıyla silindi."
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
    
    func getOtherDegrees() -> [String] {
        ["Derin doku", "Evrelendirilemeyen"]
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
