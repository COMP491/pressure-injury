//
//  InjuryRegion.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 20.04.2024.
//

import Foundation

enum InjuryRegion: String, Codable, CaseIterable {
    
    case Ear
    case Scapula
    case Elbow
    case Sacrum
    case Cocyx
    case Iliac
    case Trochanter
    case Gluteal
    case Ankle
    case Heel
    case OccipitalRegion
    case Other
    
    var turkishName: String {
        switch self {
        case .Ear: return "Kulak"
        case .Scapula: return "Scapula"
        case .Elbow: return "Dirsek"
        case .Sacrum: return "Sacrum"
        case .Cocyx: return "Koksisk"
        case .Iliac: return "İliak"
        case .Trochanter: return "Trokanter"
        case .Gluteal: return "Gluteal"
        case .Ankle: return "Ayak Bileği"
        case .Heel: return "Topuk"
        case .OccipitalRegion: return "Oksipital Bölge"
        case .Other: return "Diğer"
        }
    }
    
    static func fromTurkishName(_ name: String) -> InjuryRegion {
        switch name {
        case "Kulak": return .Ear
        case "Scapula": return .Scapula
        case "Dirsek": return .Elbow
        case "Sacrum": return .Sacrum
        case "Koksiks": return .Cocyx
        case "İliak": return .Iliac
        case "Trokanter": return .Trochanter
        case "Gluteal": return .Gluteal
        case "Ayak Bileği": return .Ankle
        case "Topuk": return .Heel
        case "Oksipital Bölge": return .OccipitalRegion
        default: return .Other
        }
    }
}
