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
        let combination = DataManager.shared.savedAlgorithms[0].wrappedStates[0].wrappedOptions[0].wrappedCombinations[0]
        ChooseDirectionView(combination: combination)
            .environmentObject(AlgorithmViewModel())
    }
}
