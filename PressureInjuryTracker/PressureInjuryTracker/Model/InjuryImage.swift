//
//  InjuryImage.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 31.03.2024.
//

import Foundation

struct InjuryImage: Codable, Hashable{
    
    var id: Int
    var grade: Double
    var diameter: Double
    var notes: [String]?
    var date: PhotoDate
}

struct PhotoDate: Codable, Hashable {
    
    let day: Int
    let month: Int
    let year: Int
}
