//
//  NewInjuryPhaseView.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 20.04.2024.
//

import SwiftUI
import UIKit
import PencilKit

struct NewInjuryPhaseView: View {
    
    @ObservedObject var viewModel: NewInjuryPhaseViewModel
    @State private var image: UIImage?
    @State private var drawing: PKDrawing?
    @State private var canvasBounds: CGRect?
    @State private var showCanvas: Bool = false
    @State private var showMeasureForWidth: Bool = false
    @State private var showMeasureForLength: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    init(viewModel: NewInjuryPhaseViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if viewModel.uploading {
                LoadingView()
            } else {
                HStack {
                    Spacer()
                    
                    if (image != nil) {
                        Button("Kaydet") {
                            
                            let currentDate = Date()
                            let calendar = Calendar.current
                            
                            let photoDate = PhotoDate(
                                day: calendar.component(.day, from: currentDate),
                                month: calendar.component(.month, from: currentDate),
                                year: calendar.component(.year, from: currentDate)
                            )
                            
                            let injuryPhase = InjuryPhase(
                                id: nil,
                                injuryId: viewModel.injury.id!,
                                photoId: UUID().uuidString, // Generate a unique ID for the photo
                                photoDate: photoDate,
                                degree: Double(viewModel.degree) ?? 0.0,
                                length: Double(viewModel.length) ?? 0.0,
                                width: Double(viewModel.width) ?? 0.0,
                                notes: viewModel.notes,
                                conditionsTicked: viewModel.conditionsTicked
                            )
                            
                            viewModel.saveInjuryPhase(withImage: image, drawingData: combineDrawingAndCanvasBounds(), injuryPhase: injuryPhase)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                if let drawing = drawing, let image = image, let bounds = canvasBounds {
                    AnnotatedImageView(image: image, drawing: drawing, bounds: bounds)
                    
                } else if let capturedImage = image {
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
                    
                    Picker("Evre", selection: $viewModel.degree) {
                        ForEach(viewModel.getDegrees(), id: \.self) {
                            Text($0)
                        }
                    }
                    
                    HStack {
                        Text("En (cm):")
                            .padding(.trailing, 16)
                        TextField("Eni girin", text: $viewModel.width)
                            .keyboardType(.numberPad)
                        Spacer()
                        Button(action: {
                            showMeasureForWidth = true
                        }) {
                            Image(systemName: "camera")
                                .foregroundColor(.blue)
                        }
                        .padding(4)
                            
                    }
                    
                    HStack {
                        Text("Boy (cm):")
                            .padding(.trailing, 16)
                        TextField("Boyu girin", text: $viewModel.length)
                            .keyboardType(.numberPad)
                        Spacer()
                        Button(action: {
                            showMeasureForLength = true
                        }) {
                            Image(systemName: "camera")
                                .foregroundColor(.blue)
                        }
                        .padding(4)
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
        }
        .navigationTitle("Güncel Yara Durumu")
        .sheet(isPresented: $viewModel.showCamera) {
            CameraView(showCamera: $viewModel.showCamera, image: self.$image)
        }
        .fullScreenCover(isPresented: $showCanvas) {
            CanvasView(image: self.$image, drawing: self.$drawing, canvasBounds: self.$canvasBounds, showCanvas: self.$showCanvas)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Yara Durumu"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("Tamam")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .fullScreenCover(isPresented: $showMeasureForWidth) {
            MeasureView(measurement: $viewModel.width, measuring: $showMeasureForWidth)
        }
        .fullScreenCover(isPresented: $showMeasureForLength) {
            MeasureView(measurement: $viewModel.length, measuring: $showMeasureForLength)
        }
    }
    
    func combineDrawingAndCanvasBounds() -> Data? {
        if let drawing = self.drawing, let canvasBounds = self.canvasBounds {
            let combinedData = DrawingData(drawing: drawing, canvasBounds: canvasBounds)
            let encoder = JSONEncoder()
            do {
                let jsonData: Data
                jsonData = try encoder.encode(combinedData)
                return jsonData
            } catch {
                print("Error encoding DrawingData: \(error)")
            }
        }
        return nil
    }
}
