//
//  RemoveTextTextField.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 19.07.2022.
//

import SwiftUI

struct RemoveTextTextField: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
            }
        }
    }
}
