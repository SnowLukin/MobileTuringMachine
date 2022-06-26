//
//  TapButtonStyle.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 11.06.2022.
//

import SwiftUI

struct NoTapColorButtonStyle: ButtonStyle {
    
    var colorScheme: ColorScheme
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                ? (colorScheme == .dark ? Color.secondaryBackground : Color.background)
                : (colorScheme == .dark ? Color.secondaryBackground : Color.background)
            )
    }
}
