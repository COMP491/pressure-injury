//
//  NewInjuryPhaseView.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 20.04.2024.
//

import SwiftUI
import UIKit

struct NewInjuryPhaseView: View {
    
    @ObservedObject var viewModel: NewInjuryPhaseViewModel
    @State private var image: UIImage?
    @State private var showCanvas: Bool = false
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
                                length: Double(viewModel.height) ?? 0.0,
                                width: Double(viewModel.width) ?? 0.0,
                                notes: viewModel.notes,
                                conditionsTicked: viewModel.conditionsTicked
                            )
                            
                            viewModel.saveInjuryPhase(withImage: image, injuryPhase: injuryPhase)
                        }
                        .padding(.horizontal)
                    }
                    
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
                    }
                    
                    HStack {
                        Text("Boy (cm):")
                            .padding(.trailing, 16)
                        TextField("Boyu girin", text: $viewModel.height)
                            .keyboardType(.numberPad)
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
            CanvasView(image: self.$image, showCanvas: self.$showCanvas)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Yara Durumu"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Tamam")))
        }
    }
}
