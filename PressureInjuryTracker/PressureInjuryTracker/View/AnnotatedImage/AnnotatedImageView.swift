//
//  AnnotatedImageView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 27.04.2024.
//

import SwiftUI
import PencilKit

struct AnnotatedImageView: View {
    
    let image: UIImage
    let drawing: PKDrawing
    let bounds: CGRect
    @State var withAnnotation: Bool = true
    
    var body: some View {
        Image(uiImage: withAnnotation ? drawingImage() : image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay {
                VStack {
                    HStack (alignment: .top) {
                        Spacer()
                        Image(systemName: "square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 28, height: 28)
                            .foregroundColor(.white)
                            .padding(4)
                            .overlay{
                                Image(systemName: withAnnotation ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                    .onTapGesture {
                                        withAnnotation.toggle()
                                    }
                            }
                    }
                    Spacer()
                }
            }
    }
    
    
    func drawingImage() -> UIImage {
        let imageRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let renderer = UIGraphicsImageRenderer(bounds: imageRect)
        return renderer.image { (ctx) in
            self.image.draw(in: imageRect)
            self.drawing.image(from: imageRect, scale: 1.0).draw(in: imageRect)
        }
    }
}
