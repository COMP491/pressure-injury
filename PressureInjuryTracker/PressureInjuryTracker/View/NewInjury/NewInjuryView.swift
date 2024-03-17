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
    @State private var showCamera: Bool = false
    @State private var image: UIImage?
    @State private var region = ""
    @State private var degree = ""
    @State private var width = ""
    @State private var height = ""
    @State private var notes = ""
    
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
                
            } else {
                Button("Fotoğraf ekle") {
                    self.showCamera = true
                }
                .padding()
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Bölge:")
                        .padding(1.8)
                    Text("Derece:")
                        .padding(1.8)
                    Text("En (cm):")
                        .padding(1.8)
                    Text("Boy (cm):")
                        .padding(1.8)

                }
                .padding()
                
                VStack(alignment: .leading) {
                    TextField("Bölgeyi girin", text: $region)
                    TextField("Dereceyi girin", text: $degree)
                    TextField("Eni girin", text: $width)
                    TextField("Boyu girin", text: $height)
                }
                .padding()
            }
            Text("Notlar:")
                .padding(1.8)
                .bold()
            TextEditor(text: $notes)
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .padding(.horizontal)
                .border(Color.gray, width: 1)
                .padding(.horizontal)
        }
        .sheet(isPresented: $showCamera) {
            CameraView(showCamera: self.$showCamera, image: self.$image)
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var showCamera: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update the view controller if needed
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.showCamera = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showCamera = false
        }
    }
}

#Preview {
    NewInjuryView(viewModel: NewInjuryViewModel(patient: Patient(barcode: "testBarcode")))
}