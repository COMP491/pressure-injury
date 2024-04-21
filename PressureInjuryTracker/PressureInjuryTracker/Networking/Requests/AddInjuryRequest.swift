//
//  AddInjuryRequest.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 20.04.2024.
//

import Foundation

struct AddInjuryRequest: Codable {
    let barcode: String
    let region: InjuryRegion
    let location: InjuryLocation
    let date: String
    // Add other properties as needed
}
