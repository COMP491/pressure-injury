//
//  WimaClassificationDTO.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 14.05.2024.
//

import Foundation

struct WimaClassificationDTO: Codable {
    let prediction: String
    let gradImageData: Data
}
