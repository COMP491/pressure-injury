//
//  Segmentation.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 19.05.2024.
//

import SwiftUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
struct Segmentation: UIViewRepresentable {
    var image: UIImage
    let imageView = LiftImageView()
    
    func makeUIView(context: Context) -> some UIView {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        Task {
            
            if let image = imageView.image, let cgImage = image.cgImage, let mask = try segment(image: cgImage) {
                imageView.image = UIImage(ciImage: mask)
            }
        }
    }
    
    func segment(image: CGImage) throws -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        
        try handler.perform([request])
        
        guard let result = request.results?.first else {
            print("No results found")
            return nil
        }
        
        let maskPixelBuffer = try result.generateScaledMaskForImage(
            forInstances: result.allInstances,
            from: handler
        )
        
        return CIImage(cvPixelBuffer: maskPixelBuffer)
    }
    
    func apply(mask: CIImage, toImage image: CIImage) -> CIImage? {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage
    }
}


class LiftImageView: UIImageView {
    // Use intrinsicContentSize to change the default image size
    // so that we can change the size in our SwiftUI View
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
