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
    @State var showGrad = true
    
    
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
                    HStack {
                        LegendView()
                        Spacer()
                        Toggle(isOn: $showGrad, label: {
                            Text("")
                                .foregroundColor(.white)
                        })
                        .toggleStyle(CustomToggleStyle())
                        .padding()
                    }

                    
                    Spacer()
                    
                    if let gradData = viewModel.gradcamImageData, let gradUIImage = UIImage(data: gradData),
                       let resizedData = viewModel.resizedImageData, let resizedUIImage = UIImage(data: resizedData){
                        Image(uiImage: showGrad ? gradUIImage : resizedUIImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.vertical, 32)
                            .padding(.horizontal, 8)
                    }
                    
                    Spacer()
                    
                    HStack {

                        Button("İptal") {
                            predicting = false
                        }
                        .padding(8)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.leading, 32)
                        Spacer()
                        Text("Evre: " + viewModel.getPrediction())
                            .foregroundStyle(Color.white)
                        Spacer()
                        Button("Onayla") {
                            prediction = viewModel.getPrediction()
                            predicting = false
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.trailing, 32)

                    }
                    .padding()
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
        }
    }
}

struct LegendView: View {
    var body: some View {
        HStack {
            Text("Çevresel Bölge")
                .foregroundStyle(Color.white)
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan, Color.green, Color.yellow, Color.red]), startPoint: .leading, endPoint: .trailing))
                .frame(height: 20)
            Text("Kritik Bölge")
                .foregroundStyle(Color.white)
        }
        .padding()
    }
}
