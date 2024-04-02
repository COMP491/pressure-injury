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
                InjuryRowView(viewModel: InjuryRowViewModel(injury: Injury(region: injury.region, grade: injury.grade)))
            }
        }
    }
}

#Preview {
    InjuryListView(viewModel: InjuryListViewModel(patient: Patient(barcode: "testBarcode")))
}
