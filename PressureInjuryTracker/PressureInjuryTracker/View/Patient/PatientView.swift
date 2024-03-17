//
//  PatientView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 5.03.2024.
//

import SwiftUI

struct PatientView: View {
    
    @ObservedObject var viewModel: PatientViewModel
    
    init(viewModel: PatientViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Image(systemName: "person.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("Ad Soyad:")
                    Text("Cinsiyet:")
                    Text("Yaş:")
                    Text("Kilo:")
                    Text("Boy:")
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Ali Yılmaz")
                    Text("Erkek")
                    Text("36")
                    Text("90")
                    Text("180")
                }
                .padding()
            }


            Spacer()
            Spacer()
            
            HStack {
                Button("Yaralar"){
                    
                }
                .padding(32)
                
                Spacer()
                
                NavigationLink("Yeni Yara", destination: NewInjuryView(viewModel: NewInjuryViewModel(patient: viewModel.patient)))
                .padding(32)
            }
        }
        .navigationTitle(viewModel.getBarcode())
    }
}

#Preview {
    PatientView(viewModel: PatientViewModel(patient: Patient(barcode: "testBarcode")))
}
