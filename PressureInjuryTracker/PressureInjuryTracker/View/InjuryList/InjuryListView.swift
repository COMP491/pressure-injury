//
//  InjuryListView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import SwiftUI

struct InjuryListView: View {
    @ObservedObject var viewModel: InjuryListViewModel
    @State var mustReloadList = false

    var body: some View {
        Group {
            if viewModel.isLoadingList {
                LoadingView()
            } else {
                List(viewModel.injuryList, id: \.self) { injury in
                    InjuryRowView(viewModel: InjuryRowViewModel(injury: Injury(id: injury.id, region: injury.region, location: injury.location, date: injury.date, injuryPhases: nil), patient: viewModel.patient), mustReloadList: $mustReloadList)
                }
            }
        }
        .navigationTitle("Yara Listesi")
        .onAppear {
            if mustReloadList {
                viewModel.reloadList()
                mustReloadList = false
            }
        }
    }
}

#Preview {
    InjuryListView(viewModel: InjuryListViewModel(patient: Patient(barcode: "114123124", name: "Testing", gender: "Erkek", age: 236, injuries: nil)))
}

