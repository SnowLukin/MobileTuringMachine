//
//  TapButtonStyle.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 11.06.2022.
//

import SwiftUI

// MARK: Makes button stay .background color when pressed
struct NoTapColorButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.secondaryBackground : Color.secondaryBackground)
    }
}
