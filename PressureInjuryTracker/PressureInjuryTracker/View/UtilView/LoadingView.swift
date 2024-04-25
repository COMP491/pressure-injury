//
//  LoadingView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 17.03.2024.
//

import SwiftUI

struct LoadingView: View {

    var body: some View {
        VStack(spacing: Spacing.spacing_1) {
            ProgressView()
            Text("Yükleniyor...")
        }
    }
}

#Preview {
    LoadingView()
}
