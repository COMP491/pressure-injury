//
//  InjuryPhaseListView.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 21.04.2024.
//

import SwiftUI

struct InjuryPhaseListView: View {
    @ObservedObject var viewModel: InjuryPhaseListViewModel
    let injury: Injury
    
    init(viewModel: InjuryPhaseListViewModel, injury: Injury) {
        self.viewModel = viewModel
        self.injury = injury
    }

    var body: some View {

        Group {
            if !viewModel.phasesLoaded {
                HStack (alignment: .center) {
                    Spacer()
                    LoadingView()
                        .padding(.vertical, 180)
                    Spacer()
                }
            } else {
                ScrollView(.horizontal) {
                    HStack (alignment: .top) {
                        ForEach(viewModel.injuryPhases) { injuryPhase in
                            VStack (alignment: .leading) {
                                if let imageData = injuryPhase.image, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 400)
                                        .border(.primary)
                                        .cornerRadius(16)
                                        .onTapGesture {
                                            viewModel.displayImageFullscreen(imageData: imageData)
                                        }
                                }
                                
                                Text("\(injuryPhase.photoDate.day).\(injuryPhase.photoDate.month).\(String(injuryPhase.photoDate.year))")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                
                                HStack {
                                    Text("Evre: ")
                                        .bold()
                                    Text("\(String(format: "%.0f", injuryPhase.degree))")
                                }
                                .padding(.horizontal, 8)
                                
                                HStack {
                                    Text("Boy (cm): ")
                                        .bold()
                                    Text("\(String(format: "%.2f", injuryPhase.length))")
                                }
                                .padding(.horizontal, 8)
                                
                                HStack {
                                    Text("En (cm): ")
                                        .bold()
                                    Text("\(String(format: "%.2f", injuryPhase.width))")
                                }
                                .padding(.horizontal, 8)
                                
                                let trueConditions = viewModel.conditionsForPhase(injuryPhase)
                                if !trueConditions.isEmpty {
                                    Text(trueConditions.joined(separator: ", "))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 8)
                                }
                                
                                Text("Notlar ")
                                    .bold()
                                    .underline()
                                    .padding(8)

                                ScrollView(.vertical) {
                                    Text(injuryPhase.notes ?? "")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(8)
                                Spacer()
                            }
                            .background(Color(red: 238, green: 238, blue: 238))
                            .cornerRadius(16)
                            .shadow(radius: 4)
                            .padding(0)
                            .frame(maxWidth: 300)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .sheet(isPresented: $viewModel.isImageFullScreenPresented) {
            if let imageData = viewModel.selectedImageData, let uiImage = UIImage(data: imageData) {
                VStack {
                    Spacer()
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Spacer()
                }
            }
        }
        .navigationTitle("Yara Geçmişi")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            NavigationLink(destination: NewInjuryPhaseView(viewModel: NewInjuryPhaseViewModel(injury: injury))) {
                Image(systemName: "plus")
            }
        )
        .onAppear {
            viewModel.getInjuryPhases(injury: injury)
        }
        .onDisappear {
            viewModel.phasesLoaded = false
        }
    }
}
