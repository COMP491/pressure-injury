//
//  InjuryImage.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 31.03.2024.
//

import Foundation

struct InjuryPhase: Codable, Hashable {
    let id: Int64?
    var injuryId: Int64
    var photoId: String
    var photoDate: PhotoDate
    var degree: String
    var length: Double
    var width: Double
    var notes: String?
    var conditionsTicked: [Bool]
}

struct PhotoDate: Codable, Hashable {
    
    let day: Int
    let month: Int
    let year: Int
}
