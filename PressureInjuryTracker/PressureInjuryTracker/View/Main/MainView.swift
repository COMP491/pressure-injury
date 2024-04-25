//
//  MainView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 2.04.2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            TabView(selection: $viewModel.selectedTab) {
                PatientView(viewModel: PatientViewModel(patient: viewModel.patient))
                    .tabItem {
                        Image(systemName: "person")
                        Text("Hasta Bilgisi")
                    }
                    .tag(0)
                
                NewInjuryView(viewModel: NewInjuryViewModel(), patient: viewModel.patient)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                        Text("Yeni Yara")
                    }
                    .tag(1)
                
                InjuryListView(viewModel: InjuryListViewModel(patient: viewModel.patient))
                    .tabItem {
                        Image(systemName: "bandage")
                        Text("Yaralar")
                    }
                    .tag(2)


            }
            .accentColor(.blue)
            .gesture(DragGesture(minimumDistance: 16, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.width < 0 {
                                // Swiped left
                                if viewModel.selectedTab < 2 { viewModel.selectedTab += 1 }
                            } else if value.translation.width > 0 {
                                // Swiped right
                                if viewModel.selectedTab > 0 { viewModel.selectedTab -= 1 }
                            }
                        }))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Çıkış") {
                    viewModel.exitFunc()
                }
            }
        }
        .navigationTitle(viewModel.patient.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainView(viewModel: MainViewModel(patient: Patient(barcode: "114123124", name: "Testing", gender: "Erkek", age: 236, injuries: nil), exitFunc: {}))
}
