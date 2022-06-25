//
//  ChooseCharView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 10.06.2022.
//

import SwiftUI

struct ChooseCharView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let algorithm: Algorithm
    let tape: Tape
    let state: StateQ
    let option: Option
    let combination: Combination
    
    var body: some View {
        Form {
            ForEach(tape.alphabetArray, id: \.self) { alphabetElement in
                Button {
                    viewModel.updateCombinationToChar(
                        algorithm: algorithm,
                        state: state,
                        option: option,
                        combination: combination,
                        alphabetElement: alphabetElement
                    )
                } label : {
                    HStack {
                        Text(alphabetElement)
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.isChosenChar(
                            algorithm: algorithm,
                            state: state,
                            option: option,
                            tape: tape,
                            combination: combination,
                            alphabetElement: alphabetElement
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
                }.buttonStyle(NoTapColorButtonStyle())
            }
        }
        .navigationTitle("Choose character")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseCharView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCharView(
            algorithm:
                Algorithm(
                    name: "New Algorithm",
                    tapes: [],
                    states: [],
                    stateForReset: StateQ(nameID: 0, options: [])
                ),
            tape: Tape(nameID: 0, components: []),
            state: StateQ(nameID: 0, options: []),
            option: Option(id: 0, toState: StateQ(nameID: 0, options: []), combinations: []),
            combination: Combination(id: 0, character: "_", direction: .stay, toCharacter: "_")
        )
        .environmentObject(AlgorithmViewModel())
    }
}
