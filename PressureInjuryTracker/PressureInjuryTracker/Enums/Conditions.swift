//
//  Conditions.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 6.05.2024.
//

import Foundation

enum Conditions: String, CaseIterable {
    case kemoterapi
    case azalmışMentalDurum
    case sigara
    case dehidrasyon
    case hareketKısıtlılığı
    case sürtünme
    case diyabet
    case cerrahiGirişim
    case dolaşımBozukluğu
    case yatağaBağımlılık
    case nem
    case basınç
    
    func displayText() -> String {
        return self.rawValue.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression, range: nil).capitalized
    }
    
    static func displayText(forIndex index: Int) -> String? {
        guard index >= 0 && index < allCases.count else {
            return nil
        }
        return allCases[index].displayText()
    }
    
    static func index(forConditionText text: String) -> Int? {
        guard let condition = allCases.first(where: { $0.rawValue.localizedCaseInsensitiveContains(text) }) else {
            return nil
        }
        return allCases.firstIndex(of: condition)
    }
    
    static func allDisplayTexts() -> [String] {
        return allCases.map { $0.displayText() }
    }
    
    static func conditionCount() -> Int {
        return allCases.count
    }
}

