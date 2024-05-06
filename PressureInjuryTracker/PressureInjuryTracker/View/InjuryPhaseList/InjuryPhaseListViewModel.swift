//
//  InjuryPhaseListViewModel.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 21.04.2024.
//

import Foundation

class InjuryPhaseListViewModel: ObservableObject {
    
    private let injuryPhaseService = InjuryPhaseService()
    private let injuryService = InjuryService()
    @Published var injuryPhases: [InjuryPhaseDTO] = []
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var phasesLoaded = false
    @Published var selectedImageData: Data? = nil
    @Published var isImageFullScreenPresented: Bool = false
    @Published var deletingInjury = false
    private let conditionCount: Int
    
    init() {
        self.conditionCount = Conditions.conditionCount()
    }
    
    func getInjuryPhases(injury: Injury) {
        injuryPhaseService.getInjuryPhases(injury: injury) { result in
            switch result {
            case .success(let injuryPhases):
                DispatchQueue.main.async {
                    self.injuryPhases = injuryPhases
                    self.phasesLoaded = true
                    print(injuryPhases)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alertMessage = "Yara geçmişi yüklenemedi: \(error)"
                    self.showAlert = true
                }
            }
        }
    }
    
    func displayImageFullscreen(imageData: Data) {
        self.selectedImageData = imageData
        self.isImageFullScreenPresented = true
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
    
    func conditionsForPhase(_ phase: InjuryPhaseDTO) -> [String] {
        var trueConditions: [String] = []
        for (index, condition) in phase.conditionsTicked.enumerated() {
            if condition {
                trueConditions.append(getConditionsNames(index: index))
            }
        }
        return trueConditions
    }
    
    func deleteInjury(_ injury: Injury) {
        self.deletingInjury = true
        injuryService.deleteInjury(injury) { result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    self.alertMessage = "Yara silindi"
                    self.showAlert = true
                    self.deletingInjury = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alertMessage = "Yara silinemedi: \(error)"
                    self.showAlert = true
                    self.deletingInjury = false
                }
            }
        }
    }
}

