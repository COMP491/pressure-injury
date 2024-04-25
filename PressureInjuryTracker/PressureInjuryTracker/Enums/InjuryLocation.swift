//
//  InjuryLocation.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 20.04.2024.
//

import Foundation

enum InjuryLocation: String, Codable, CaseIterable {
    
    case Right
    case Left
    case Other
    
    var turkishName: String {
        switch self {
        case .Right: return "Sağ"
        case .Left: return "Sol"
        case .Other: return "Diğer"
        }
    }
    
    static func fromTurkishName(_ name: String) -> InjuryLocation {
        switch name {
        case "Sağ": return .Right
        case "Scapula": return .Left
        case "Diğer": return .Other
        default: return .Other
        }
    }
}
