//
//  ChooseCharView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 10.06.2022.
//

import SwiftUI

struct ChooseCharView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let combination: Combination
    let tape: Tape
    
    var body: some View {
        Form {
            ForEach(tape.alphabetArray, id: \.self) { alphabetElement in
                Button {
                    viewModel.updateCombinationToChar(combination: combination, alphabetElement: alphabetElement)
                } label : {
                    HStack {
                        Text(alphabetElement)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if viewModel.isChosenChar(combination: combination, alphabetElement: alphabetElement) {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .transition(
                                    AnyTransition.opacity.animation(
                                        .easeInOut(duration: 0.2)
                                    )
                                )
                        }
                    }
                }.buttonStyle(
                    NoTapColorButtonStyle(colorScheme: colorScheme)
                )
            }
        }
        .navigationTitle("Choose character")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseCharView_Previews: PreviewProvider {
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
        let combination = option.wrappedCombinations[0]
        let tape = algorithm.wrappedTapes[0]
        
        return ChooseCharView(combination: combination, tape: tape)
            .environmentObject(AlgorithmViewModel())
    }
}
