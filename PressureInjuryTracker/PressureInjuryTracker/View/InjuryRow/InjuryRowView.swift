//
//  InjuryRowView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import SwiftUI

struct InjuryRowView: View {
    
    @ObservedObject var viewModel: InjuryRowViewModel
    @Binding var mustReloadList: Bool
    
    init(viewModel: InjuryRowViewModel, mustReloadList: Binding<Bool>) {
        self.viewModel = viewModel
        self._mustReloadList = mustReloadList
    }

    var body: some View {
        NavigationLink(destination: InjuryPhaseListView(viewModel: InjuryPhaseListViewModel(), injury: viewModel.injury, mustReloadList: $mustReloadList)) {
            HStack(spacing: .zero) {
                Text("\((viewModel.injury.location.turkishName == "Diğer" ? "" : viewModel.injury.location.turkishName + " ") + viewModel.injury.region.turkishName)")
                    .padding()
                Spacer()
                Text("\(viewModel.dateFormatter.string(from: viewModel.injury.date))")
                    .padding()
            }
            .padding(.vertical, Spacing.spacing_1)
            .overlay {
                RoundedRectangle(cornerRadius: Radius.radius_2)
                    .stroke(lineWidth: 2)
            }
            .navigationTitle("Yara Listesi")
        }
    }
}



