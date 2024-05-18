//
//  SegmentationView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 19.05.2024.
//

import SwiftUI

struct SegmentationView: View {
    var image: UIImage
    
    var body: some View {
        Segmentation(image: image)
    }
}

#Preview {
    SegmentationView(image: UIImage(named: "EVRE3")!)
}
