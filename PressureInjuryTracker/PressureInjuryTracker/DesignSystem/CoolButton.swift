//
//  CoolButton.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 14.05.2024.
//

import SwiftUI

struct CoolButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 0)
                Image(systemName: "sparkles")
                    .foregroundColor(.white)
                    .padding(0)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15)
        }
    }
}


#Preview {
    CoolButton(title: "WIMA") {
        
    }
}
