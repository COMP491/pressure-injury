//
//  Injury.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import Foundation

struct Injury: Codable, Hashable {
    
    let id: Int64?
    let region: InjuryRegion
    let location: InjuryLocation
    let date: Date
    let injuryPhases: [InjuryPhase]?

}

