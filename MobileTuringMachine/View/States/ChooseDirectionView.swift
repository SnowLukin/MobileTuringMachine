//
//  ChooseDirectionView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 10.06.2022.
//

import SwiftUI

struct ChooseDirectionView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let algorithm: Algorithm
    let tape: Tape
    let state: StateQ
    let option: Option
    let combination: Combination
    
    var body: some View {
        Form {
            ForEach(Direction.allCases, id: \.self) { direction in
                Button {
                    viewModel.updateCombinationDirection(
                        algorithm: algorithm,
                        state: state,
                        option: option,
                        combination: combination,
                        direction: direction
                    )
                } label: {
                    HStack {
                        Image(systemName: direction.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.isChosenDirection(
                            algorithm: algorithm,
                            state: state,
                            option: option,
                            tape: tape,
                            combination: combination,
                            direction: direction
                        ) {
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
        ChooseDirectionView(
            algorithm:
                Algorithm(
                    name: "New Algorithm",
                    tapes: [],
                    states: [],
                    stateForReset: StateQ(nameID: 0, options: [])
                ),
            tape: Tape(nameID: 0, components: []),
            state: StateQ(nameID: 0, options: []),
            option: Option(toState: StateQ(nameID: 0, options: []), combinations: []),
            combination: Combination(character: "_", direction: .stay, toCharacter: "_")
        )
        .environmentObject(AlgorithmViewModel())
    }
}
