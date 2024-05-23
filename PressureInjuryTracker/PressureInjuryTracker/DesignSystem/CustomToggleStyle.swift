//
//  CustomToggleStyle.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 23.05.2024.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Button(action: { configuration.isOn.toggle() }) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(configuration.isOn ? LinearGradient(gradient: Gradient(colors: [Color.red, Color.yellow, Color.green, Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color.white]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .foregroundColor(.white)
                            .shadow(color: configuration.isOn ? .blue : .gray, radius: 3, x: 1, y: 1)
                            .padding(1)
                            .offset(x: configuration.isOn ? 10 : -10)
                            .animation(.easeInOut(duration: 0.2))
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
