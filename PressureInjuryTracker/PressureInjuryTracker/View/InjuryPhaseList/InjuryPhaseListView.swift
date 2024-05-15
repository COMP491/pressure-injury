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
    @State private var showDeleteConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var mustReloadList: Bool
    
    @State private var zoomScale: CGFloat = 1.0
    
    init(viewModel: InjuryPhaseListViewModel, injury: Injury, mustReloadList: Binding<Bool>) {
        self.viewModel = viewModel
        self.injury = injury
        self._mustReloadList = mustReloadList
    }

    var body: some View {

        Group {
            if !viewModel.phasesLoaded || viewModel.deletingInjury {
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
                            listItem(injuryPhase)
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
                ZoomableScrollView {
                  Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(8)
                }
            }
        }
        .navigationTitle("Yara Geçmişi")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: HStack {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Text("Yarayı Sil")
                        .padding(.horizontal, 4)
                        .foregroundStyle(Color.red)
                        .bold()
                }
                
                NavigationLink(destination: NewInjuryPhaseView(viewModel: NewInjuryPhaseViewModel(injury: injury))) {
                    Image(systemName: "plus")
                }
            }

        )
        .onAppear {
            viewModel.getInjuryPhases(injury: injury)
        }
        .onDisappear {
            viewModel.phasesLoaded = false
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Yarayı Sil"),
                message: Text("Bu yarayı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz."),
                primaryButton: .destructive(Text("Sil"), action: {
                    viewModel.deleteInjury(injury)
                    mustReloadList = true
                    presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel(Text("İptal"), action: {
                    viewModel.deletingInjury = false
                })
            )
        }
    }
    
    func listItem(_ injuryPhase: InjuryPhaseDTO) -> some View {
        
        return VStack (alignment: .leading) {
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
            
            NavigationLink(destination: InjuryPhaseDetailView(viewModel: InjuryPhaseDetailViewModel(injury: injury, injuryPhase: injuryPhase))) {
                VStack (alignment: .leading) {
                    Text("\(injuryPhase.photoDate.day).\(injuryPhase.photoDate.month).\(String(injuryPhase.photoDate.year))")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                    
                    HStack {
                        Text("Evre: ")
                            .bold()
                            .foregroundStyle(Color.black)
                        Text("\(String(format: "%.0f", injuryPhase.degree))")
                            .foregroundStyle(Color.black)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text("En (cm): ")
                            .bold()
                            .foregroundStyle(Color.black)
                        Text("\(String(format: "%.2f", injuryPhase.width))")
                            .foregroundStyle(Color.black)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text("Boy (cm): ")
                            .bold()
                            .foregroundStyle(Color.black)
                        Text("\(String(format: "%.2f", injuryPhase.length))")
                            .foregroundStyle(Color.black)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    let trueConditions = viewModel.conditionsForPhase(injuryPhase)
                    if !trueConditions.isEmpty {
                        HStack {
                            Text(trueConditions.joined(separator: ", "))
                                .foregroundStyle(.gray)
                                .padding(.horizontal, 8)
                            
                            Spacer()
                        }

                    }
                    
                    HStack {
                        Text("Notlar ")
                            .bold()
                            .underline()
                            .foregroundStyle(Color.black)
                            .padding(8)
                        Spacer()
                    }
                    

                    ScrollView(.vertical) {
                        Text(injuryPhase.notes ?? "")
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundStyle(Color.black)
                    }
                    .padding(8)
                }
            }
            Spacer()
        }
        .background(Color(red: 238, green: 238, blue: 238))
        .cornerRadius(16)
        .shadow(radius: 4)
        .padding(0)
        .frame(maxWidth: 300)
    }
}
