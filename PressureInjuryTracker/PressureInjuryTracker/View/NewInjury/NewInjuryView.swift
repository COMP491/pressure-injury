//
//  NewInjuryView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import SwiftUI
import UIKit

struct NewInjuryView: View {
    
    @ObservedObject var viewModel: NewInjuryViewModel
    @State private var image: UIImage?
    @State private var showCanvas: Bool = false
    
    init(viewModel: NewInjuryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                
                Button("Kaydet") {
                    // Handle using the captured photo
                }
                .padding(.horizontal)
            }
            Spacer()
            if let capturedImage = image {
                Image(uiImage: capturedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                Button("Çiz") {
                    if image != nil {
                        showCanvas = true
                    }
                }
                
            } else {
                Button("Fotoğraf ekle") {
                    viewModel.showCamera = true
                }
                .padding()
                
            }
            
            List {
                Picker("Bölge", selection: $viewModel.region) {
                    ForEach(viewModel.getRegions(), id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Lokasyon", selection: $viewModel.location) {
                    ForEach(viewModel.getLocations(), id: \.self) {
                        Text($0)
                    }
                }
                
                HStack {
                    Text("Bölge açıklaması:")
                        .padding(.trailing, 16)
                    TextField("Yara bölgesini açıklayın", text: $viewModel.regionDescription)
                }
                
                
                Picker("Derece", selection: $viewModel.degree) {
                    ForEach(viewModel.getDegrees(), id: \.self) {
                        Text($0)
                    }
                }
                
                HStack {
                    Text("En (cm):")
                        .padding(.trailing, 16)
                    TextField("Eni girin", text: $viewModel.width)
                }
                
                HStack {
                    Text("Boy (cm):")
                        .padding(.trailing, 16)
                    TextField("Boyu girin", text: $viewModel.height)
                }
                
                ForEach(0..<viewModel.getConditionCount(), id: \.self) { index in
                    Button(action: {
                        viewModel.conditionsState[index].toggle()
                    }) {
                        HStack {
                            Image(systemName: viewModel.conditionsState[index] ? "checkmark.square.fill" : "square")
                            Text(viewModel.getConditionsNames(index: index))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text("Notlar ve Açıklamalar:")
                    .padding(1.8)
                    .bold()
                TextEditor(text: $viewModel.notes)
                    .frame(height: 220)
                    .padding(.horizontal)
                    .border(Color.gray, width: 1)
                    .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Kapat") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showCamera) {
            CameraView(showCamera: $viewModel.showCamera, image: self.$image)
        }
        .fullScreenCover(isPresented: $showCanvas) {
            CanvasView(image: self.$image, showCanvas: self.$showCanvas)
        }
    }
}
