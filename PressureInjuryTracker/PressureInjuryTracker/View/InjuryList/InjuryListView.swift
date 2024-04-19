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
        if viewModel.isLoadingList {
            LoadingView()
                .onAppear {
                    viewModel.loadInjuryList()
                }
        } else {
            List(viewModel.injuryList, id: \.self) { injury in
                InjuryRowView(viewModel: InjuryRowViewModel(injury: Injury(location: injury.location, registrationDate: injury.registrationDate)))
            }
        }
    }
}

#Preview {
    InjuryListView(viewModel: InjuryListViewModel(patient: Patient(barcode: "114123124", name: "Testing", gender: "Male", age: 236, injuries: nil)))
}

