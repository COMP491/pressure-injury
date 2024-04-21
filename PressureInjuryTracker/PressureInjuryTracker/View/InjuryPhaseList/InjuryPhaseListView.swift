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
    
    init(viewModel: InjuryPhaseListViewModel, injury: Injury) {
        self.viewModel = viewModel
        self.injury = injury
    }

    var body: some View {
        NavigationView {
            List(viewModel.injuryPhases, id: \.id) { injuryPhase in
                VStack(alignment: .leading) {
                    if let imageData = injuryPhase.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Text("Degree: \(String(format: "%.2f", injuryPhase.degree))")
                    Text("Length: \(String(format: "%.2f", injuryPhase.length))")
                    Text("Width: \(String(format: "%.2f", injuryPhase.width))")
                    Text("Notes: \(injuryPhase.notes ?? "")")
                }
            }
            .navigationBarTitle("Injury Phases", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: NewInjuryPhaseView(viewModel: NewInjuryPhaseViewModel(injury: injury))) {
                    Image(systemName: "plus")
                }
            )
            .onAppear {
                viewModel.getInjuryPhases(injury: injury)
            }
        }
    }
}



