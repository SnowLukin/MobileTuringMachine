//
//  ChooseStateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 11.06.2022.
//

import SwiftUI

struct ChooseStateView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let algorithm: Algorithm
    let state: StateQ
    let option: Option
    
    var body: some View {
        List {
            ForEach(viewModel.getAlgorithm(algorithm).states) { currentState in
                Button {
                    viewModel.updateOptionToState(
                        algorithm: algorithm,
                        state: state,
                        option: option,
                        currentState: currentState
                    )
                } label: {
                    HStack {
                        Text("State \(currentState.nameID)")
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.isChosenToState(
                            algorithm: algorithm,
                            state: state,
                            option: option,
                            currentState: currentState
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
                .buttonStyle(
                    NoTapColorButtonStyle(colorScheme: colorScheme)
                )
            }
        }
    }
}

struct ChooseStateView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseStateView(algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])), state: StateQ(nameID: 0, options: []), option: Option(id: 0, toState: StateQ(nameID: 0, options: []), combinations: []))
            .environmentObject(AlgorithmViewModel())
    }
}
