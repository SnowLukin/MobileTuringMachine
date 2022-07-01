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
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        let algorithm = DataManager.shared.savedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        let combination = algorithm.wrappedStates[0].wrappedOptions[0].wrappedCombinations[0]
        
        return ChooseCharView(combination: combination, tape: tape)
            .environmentObject(AlgorithmViewModel())
    }
}
