//
//  WimaClassificationViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 14.05.2024.
//

import Foundation

class WimaClassificationViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var gradcamImageDAta: Data?
    @Published var originalPrediction: String
    
    private let imageData: Data?
    private var prediction: String?
    
    init(imageData: Data?, originalPrediction: String) {
        self.imageData = imageData
        self.originalPrediction = originalPrediction
        predict()
    }
    
    
    func getPrediction() -> String {
        return prediction ?? "NO PREDICTION"
    }
    
    func predict() {
        self.prediction = "1"
        self.isLoading = false
    }
}
