//
//  InjuryPhaseDTO.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 21.04.2024.
//

import Foundation

struct InjuryPhaseDTO: Codable, Hashable {
    let id: Int64?
    var photoDate: PhotoDate
    var degree: Double
    var length: Double
    var width: Double
    var notes: String?
    var conditionsTicked: [Bool]
    var image: Data?
}
