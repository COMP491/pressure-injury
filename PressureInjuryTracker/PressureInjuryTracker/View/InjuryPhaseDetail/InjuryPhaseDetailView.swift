//
//  InjuryPhaseDetailView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 27.04.2024.
//

import SwiftUI
import UIKit
import PencilKit

struct InjuryPhaseDetailView: View {
    
    @ObservedObject var viewModel: InjuryPhaseDetailViewModel
    @State private var image: UIImage?
    @State private var drawing: PKDrawing?
    @State private var canvasBounds: CGRect?
    @State private var showCanvas: Bool = false
    @State private var showMeasureForWidth: Bool = false
    @State private var showMeasureForLength: Bool = false
    @State private var showAIPrediction: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    init(viewModel: InjuryPhaseDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if viewModel.uploading {
                LoadingView()
            } else {
                HStack {
                    
                    Button("Kaydı Sil") {
                        showDeleteConfirmation = true
                    }
                    .padding(.horizontal)
                    .foregroundStyle(Color.red)
                    .bold()
                    
                    Spacer()
                    
                    if (image != nil) {
                        Button("Kaydet") {
                            
                            let photoDate: PhotoDate = viewModel.injuryPhase.photoDate
                            
                            let injuryPhase = InjuryPhase(
                                id: viewModel.injuryPhase.id,
                                injuryId: viewModel.injury.id!,
                                photoId: UUID().uuidString, // Generate a unique ID for the photo
                                photoDate: photoDate,
                                degree: Double(viewModel.degree) ?? 0.0,
                                length: Double(viewModel.length) ?? 0.0,
                                width: Double(viewModel.width) ?? 0.0,
                                notes: viewModel.notes,
                                conditionsTicked: viewModel.conditionsTicked
                            )
                            
                            viewModel.editInjuryPhase(drawingData: combineDrawingAndCanvasBounds(), injuryPhase: injuryPhase)
                        }
                        .padding(.horizontal)
                        
                    }
                }
                
                Spacer()
                
                if let image = image, let drawing = drawing, let bounds = canvasBounds {
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
                    VStack {
                        HStack {
                            Text("Evre: ")
                                .padding(0)
                            
                            ScrollView (.horizontal) {
                                HStack {
                                    Picker("Evre", selection: $viewModel.degree) {
                                        ForEach(viewModel.getDegrees(), id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(PalettePickerStyle())
                                    .padding(0)
                                    .frame(width: 128)
                                    
                                    Picker("Evre", selection: $viewModel.degree) {
                                        ForEach(["Derin Doku"], id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(PalettePickerStyle())
                                    .padding(0)
                                    .frame(width: 80)
                                    
                                    Picker("Evre", selection: $viewModel.degree) {
                                        ForEach(["Evrelendirilemeyen"], id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(PalettePickerStyle())
                                    .padding(0)
                                    .frame(width: 144)
                                }
                            }
                            
                            
                            Spacer()
                            
                            CoolButton(title: "Wima") {
                                showAIPrediction = true
                            }
                            .padding(0)
                        }
                        .padding(0)
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
            Alert(title: Text("Yara Durumu"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Tamam")))
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Kaydı Sil"),
                message: Text("Bu kaydı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz."),
                primaryButton: .destructive(Text("Sil"), action: {
                    viewModel.deleteInjuryPhase(injuryPhase: viewModel.injuryPhase)
                    presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel(Text("İptal"))
            )
        }
        .onAppear {
            if let imageData = viewModel.imageData {
                image = UIImage(data: imageData)
            }
            
            if let drawingData = viewModel.drawingData {
                separateDrawingAndCanvasBounds(combinedData: drawingData)
            }
        }
        .fullScreenCover(isPresented: $showMeasureForWidth) {
            MeasureView(measurement: $viewModel.width, measuring: $showMeasureForWidth)
        }
        .fullScreenCover(isPresented: $showMeasureForLength) {
            MeasureView(measurement: $viewModel.length, measuring: $showMeasureForLength)
        }
        .fullScreenCover(isPresented: $showAIPrediction) {
            WimaClassificationView(viewModel: WimaClassificationViewModel(imageData: viewModel.injuryPhase.image, originalPrediction: viewModel.degree), prediction: $viewModel.degree, predicting: $showAIPrediction)
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
    
    func separateDrawingAndCanvasBounds(combinedData: Data) {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DrawingData.self, from: combinedData)
            self.drawing = decodedData.drawing
            self.canvasBounds = decodedData.canvasBounds
        } catch {
            print("Error decoding DrawingData: \(error)")
        }
    }
    
}
