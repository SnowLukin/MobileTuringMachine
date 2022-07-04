//
//  ChooseDirectionView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 10.06.2022.
//

import SwiftUI

struct ChooseDirectionView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let combination: Combination
    
    var body: some View {
        Form {
            ForEach(0..<3, id: \.self) { directionID in
                Button {
                    viewModel.updateCombinationDirection(combination: combination, directionID: directionID)
                } label: {
                    HStack {
                        Image(systemName: directionID == 0 ? "arrow.counterclockwise" : directionID == 1 ? "arrow.left" : "arrow.right")
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if viewModel.isChosenDirection(combination: combination, directionID: directionID) {
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
        .navigationTitle("Choose direction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseDirectionView_Previews: PreviewProvider {
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
        
        return ChooseDirectionView(combination: combination)
            .environmentObject(AlgorithmViewModel())
    }
}
