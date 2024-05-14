//
//  SwiftUIView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 14.05.2024.
//

import SwiftUI

struct WimaClassificationView: View {
    @ObservedObject var viewModel: WimaClassificationViewModel
    @Binding var prediction: String
    @Binding var predicting: Bool
    
    
    init(viewModel: WimaClassificationViewModel, prediction: Binding<String>, predicting: Binding<Bool>) {
        self.viewModel = viewModel
        self._prediction = prediction
        self._predicting = predicting
    }
    
    var body: some View {
        
        Group {
            if viewModel.isLoading {
                
                LoadingView()
                
            } else {
                
                VStack {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    HStack {
                        Spacer()
                        Spacer()
                        
                        Button("İptal") {
                            predicting = false
                        }
                        .padding(8)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                        
                        Text("Evre: " + viewModel.getPrediction())
                        
                        Spacer()
                        
                        Button("Onayla") {
                            prediction = viewModel.getPrediction()
                            predicting = false
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
