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
            ForEach(algorithm.wrappedStates) { state in
                Button {
                    viewModel.changeStartState(to: state)
                } label: {
                    HStack {
                        Text("State \(state.nameID)")
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if state.isStarting {
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
        ChooseStartStateView(algorithm: DataManager.shared.savedAlgorithms[0])
            .environmentObject(AlgorithmViewModel())
    }
}
