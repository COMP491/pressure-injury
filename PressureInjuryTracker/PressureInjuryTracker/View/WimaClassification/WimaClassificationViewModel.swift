//
//  WimaClassificationViewModel.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 14.05.2024.
//

import Foundation

class WimaClassificationViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var gradcamImageData: Data?
    @Published var originalPrediction: String
    
    private var wimaClassification: WimaClassificationDTO?
    private let imageData: Data?
    private var prediction: String?
    private let wimaService = WimaService()
    
    init(imageData: Data?, originalPrediction: String) {
        self.imageData = imageData
        self.originalPrediction = originalPrediction
        predict()
    }
    
    
    func getPrediction() -> String {
        return prediction ?? "NO PREDICTION"
    }
    
    func predict() {
        self.isLoading = true
        wimaService.classify(imageData: self.imageData) { result in
            switch result {
            case .success(let wimaClassification):
                DispatchQueue.main.async {
                    self.wimaClassification = wimaClassification
                    self.prediction = wimaClassification.prediction
                    self.gradcamImageData = wimaClassification.gradImageData
                    self.isLoading = false
                }
            case .failure(let error):
                self.isLoading = false
                self.prediction = "Evrelendirilemeyen"
                self.gradcamImageData = self.imageData
            }
        }
    }
}
