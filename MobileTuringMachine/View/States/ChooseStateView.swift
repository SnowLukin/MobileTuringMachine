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
    
    let option: Option
    
    var body: some View {
        List {
            ForEach(option.state.algorithm.wrappedStates) { currentState in
                Button {
                    viewModel.updateOptionToState(option: option, currentState: currentState)
                } label: {
                    HStack {
                        Text("State \(currentState.nameID)")
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.isChosenToState(option: option, currentState: currentState) {
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
        let viewModel = AlgorithmViewModel()
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        for algorithm in folder.wrappedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm(to: folder)
        let algorithm = folder.wrappedAlgorithms[0]
        let state = algorithm.wrappedStates[0]
        let option = state.wrappedOptions[0]
        return ChooseStateView(option: option)
            .environmentObject(AlgorithmViewModel())
    }
}
