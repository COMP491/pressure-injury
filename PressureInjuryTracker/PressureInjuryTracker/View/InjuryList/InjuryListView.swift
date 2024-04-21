//
//  InjuryListView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import SwiftUI

struct InjuryListView: View {
    @ObservedObject var viewModel: InjuryListViewModel

    var body: some View {
        NavigationStack {
            if viewModel.isLoadingList {
                LoadingView()
                    .onAppear {
                        viewModel.loadInjuryList(patient: viewModel.patient)
                    }
            } else {
                List(viewModel.injuryList, id: \.self) { injury in
                    InjuryRowView(viewModel: InjuryRowViewModel(injury: Injury(id: injury.id, region: injury.region, location: injury.location, date: injury.date, injuryPhases: nil), patient: viewModel.patient))
                }
            }
        }
        
    }
}

#Preview {
    InjuryListView(viewModel: InjuryListViewModel(patient: Patient(barcode: "114123124", name: "Testing", gender: "Male", age: 236, injuries: nil)))
}

