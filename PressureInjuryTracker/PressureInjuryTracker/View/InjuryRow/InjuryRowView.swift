//
//  InjuryRowView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import SwiftUI

struct InjuryRowView: View {
    
    @ObservedObject var viewModel: InjuryRowViewModel

    var body: some View {
        NavigationLink(destination: InjuryPhaseListView(viewModel: InjuryPhaseListViewModel(), injury: viewModel.injury)) {
            HStack(spacing: .zero) {
                Spacer()
                Text(viewModel.injury.region.rawValue)
                Spacer()
            }
            .padding(.vertical, Spacing.spacing_1)
            .overlay {
                RoundedRectangle(cornerRadius: Radius.radius_2)
                    .stroke(lineWidth: 2)
            }
        }
    }
}



