//
//  Patient.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import Foundation

struct Patient: Codable, Hashable {
    
    let barcode: String
    let name: String
    let gender: String
    let age: Int
    let injuries: [Injury]?
    
}

