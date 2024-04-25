//
//  BarcodeScanView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import SwiftUI
import AVFoundation

struct BarcodeScanView: View {
    @ObservedObject var viewModel: StartViewModel
    @State private var isScanning = false
    @State private var scannedCode: String?

    var body: some View {
        VStack {
            
            if !isScanning {
                Image(systemName: "barcode.viewfinder")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("Barkodu Tarayın")
                
                Button(action: {
                    self.isScanning = true
                }) {
                    Text("Tara!")
                }
            }
            
            
            if isScanning {
                BarcodeScannerView(code: $scannedCode, isScanning: $isScanning)
            }
        }
        .ignoresSafeArea()
        .onChange(of: scannedCode) { oldValue, newValue in
            if let code = newValue, oldValue != newValue {
                viewModel.saveBarcode(barcode: code)
            }
        }
    }
}

struct BarcodeScannerView: UIViewControllerRepresentable {
    @Binding var code: String?
    @Binding var isScanning: Bool

    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, BarcodeScannerDelegate {
        let parent: BarcodeScannerView

        init(_ parent: BarcodeScannerView) {
            self.parent = parent
        }

        func didScanBarcode(_ code: String) {
            parent.code = code
            parent.isScanning = false
        }
    }
}

protocol BarcodeScannerDelegate: AnyObject {
    func didScanBarcode(_ code: String)
}



