//
//  Injury.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import Foundation

struct Injury: Hashable {
    let id = 0
    let region: String
    let grade: String
    
    init(region: String, grade: String) {
        self.region = region
        self.grade = grade
    }
}
