//
//  ChooseStartStateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct ChooseStartStateView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let algorithm: Algorithm
    
    var body: some View {
        List {
            ForEach(viewModel.getAlgorithm(algorithm).states) { state in
                Button {
                    viewModel.changeStartState(to: state, of: algorithm)
                } label: {
                    HStack {
                        Text("State \(state.nameID)")
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.getStartState(of: algorithm) == state {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        }
                    }
                }
                .buttonStyle(
                    NoTapColorButtonStyle(colorScheme: colorScheme)
                )
            }
        }
        .navigationTitle("Current state")
    }
}

struct ChooseStartStateView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseStartStateView(algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])))
            .environmentObject(AlgorithmViewModel())
    }
}
