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
        HStack(spacing: .zero) {
            Spacer()
            Text(viewModel.injury.region)
            Spacer()
        }
        .padding(.vertical, Spacing.spacing_1)
        .overlay {
            RoundedRectangle(cornerRadius: Radius.radius_2)
                .stroke(lineWidth: 2)
        }
        .onTapGesture {
            viewModel.injuryTapped()
        }
        .sheet(isPresented: $viewModel.injuryDataDisplayed, content: {
            EmptyView()
        })
    }
}

#Preview {
    InjuryRowView(viewModel: InjuryRowViewModel(injury: Injury(region: "Sırt", grade: "3")))
}
