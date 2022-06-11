//
//  ChooseDirectionButtonView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 11.06.2022.
//

import SwiftUI

struct ChooseDirectionButtonView: View {
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var isChosen: Bool = false
    
    let tapeID: Int
    let stateID: Int
    let optionID: Int
    let direction: Direction
    
    var body: some View {
        
        Button {
            viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction = direction
        } label: {
            HStack {
                Image(systemName: direction.rawValue)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "circle.fill")
                    .foregroundColor(.blue)
                    .opacity(
                        isChosen ? 1 : 0
                    )
            }
        }
        .buttonStyle(NoTapColorButtonStyle())
        .onAppear {
            if viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction == direction {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isChosen = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isChosen = false
                }
            }
        }
        
        .onChange(of: viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction) { newValue in
            if newValue == direction {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isChosen = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isChosen = false
                }
            }
        }
    }
}

struct ChooseDirectionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDirectionButtonView(tapeID: 0, stateID: 0, optionID: 0, direction: .stay)
    }
}
