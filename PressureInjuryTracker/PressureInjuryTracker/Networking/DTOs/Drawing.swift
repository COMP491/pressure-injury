//
//  Drawing.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 7.05.2024.
//

import Foundation
import PencilKit

struct DrawingData: Codable {
    let drawing: PKDrawing
    let canvasBounds: CGRect
}
