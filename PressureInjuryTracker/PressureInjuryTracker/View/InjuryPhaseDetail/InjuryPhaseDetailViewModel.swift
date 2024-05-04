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
    @Published var degree = "Seçiniz"
    @Published var width = ""
    @Published var length = ""
    @Published var notes = ""
    @Published var conditionsState: [Bool]
    private let conditionsNames = ["Kemoterapi", "Azalmış mental durum", "Sigara", "Dehidrasyon", "Hareket kısıtlılığı", "Sürtünme", "Diyabet", "Cerrahi girişim", "Dolaşım bozukluğu", "Yatağa bağımlılık", "Nem", "Basınç"]
    private let conditionCount: Int
    private let degrees = ["Seçiniz", "1", "2", "3", "4"]
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
        self.conditionCount = conditionsNames.count
        self.conditionsState = Array(repeating: false, count: conditionCount)
        self.degree = String(format: "%.0f", injuryPhase.degree)
        self.width = String(injuryPhase.width)
        self.length = String(injuryPhase.length)
        self.notes = injuryPhase.notes ?? ""
        self.conditionsState = injuryPhase.conditionsTicked
        self.imageData = injuryPhase.image
        self.drawingData = injuryPhase.drawingData
    }
    
    func editInjuryPhase(withImage image: UIImage?, drawingData: Data?, injuryPhase: InjuryPhase) {
        self.uploading = true
        injuryPhaseService.editInjuryPhase(withImage: image, drawingData: drawingData, injuryPhase: injuryPhase) { result in
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
    
    func deletePhase() {
        
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
