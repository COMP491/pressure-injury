//
//  Injury.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import Foundation

struct Injury: Codable, Hashable {
    
    let id: Int
    let location: String
    let registrationDate: String
    
    init(location: String, registrationDate: String) {
        self.id = 0
        self.location = location
        self.registrationDate = registrationDate
    }
}

