//
//  ChooseDirectionView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 10.06.2022.
//

import SwiftUI

struct ChooseDirectionView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    
    let tapeID: Int
    let stateID: Int
    let optionID: Int
    
    var body: some View {
        Form {
            ForEach(Direction.allCases, id: \.self) { direction in
                Button {
                    viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction = direction
                } label: {
                    HStack {
                        Image(systemName: direction.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction == direction {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .transition(
                                    AnyTransition.opacity.animation(
                                        .easeInOut(duration: 0.2)
                                    )
                                )
                        }
                    }
                }
                .buttonStyle(NoTapColorButtonStyle())
            }
        }
        .navigationTitle("Choose direction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseDirectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDirectionView(tapeID: 0, stateID: 0, optionID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
