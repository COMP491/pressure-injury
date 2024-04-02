//
//  NewInjuryViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

class NewInjuryViewModel: ObservableObject {
    
    @Published var showCamera: Bool = false
    @Published var imageData: Data?
    @Published var region = "Seçiniz"
    @Published var location = "Seçiniz"
    @Published var regionDescription = ""
    @Published var degree = "Seçiniz"
    @Published var width = ""
    @Published var height = ""
    @Published var notes = ""
    @Published var conditionsState: [Bool]
    private let conditionsNames = ["Kemoterapi", "Azalmış mental durum", "Sigara", "Dehidrasyon", "Hareket kısıtlılığı", "Sürtünme", "Diyabet", "Cerrahi girişim", "Dolaşım bozukluğu", "Yatağa bağımlılık", "Nem", "Basınç"]
    private let conditionCount: Int
    
    private let regions = ["Seçiniz", "Kulak", "Scapula", "Dirsek", "Sacrum", "Koksiks", "İliak", "Trokanter", "Gluteal", "Ayak bileği", "Topuk", "Oksipital bölge"]
    private let locations = ["Seçiniz", "Sağ", "Sol", "Diğer"]
    private let degrees = ["Seçiniz", "1", "2", "3", "4"]
    
    private let patient: Patient
    
    init(patient: Patient) {
        self.patient = patient
        self.conditionCount = conditionsNames.count
        self.conditionsState = Array(repeating: false, count: conditionCount)
    }

    func getRegions() -> [String] {
        self.regions
    }
    
    func getLocations() -> [String] {
        self.locations
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
