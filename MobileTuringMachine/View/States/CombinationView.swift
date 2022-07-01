//
//  CombinationView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let option: Option
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    ChooseStateView(option: option)
                } label: {
                    Text("Navigate to:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("State \(viewModel.getToStateName(for: option))")
                        .foregroundColor(.gray)
                }
            }
            Section(header: Text("Elements rewriting")) {
                combinationElements
            }
        }
        .navigationBarTitle(
            "Combination: \(option.wrappedCombinations.map { $0.character }.joined(separator: ""))"
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        let option = DataManager.shared.savedAlgorithms[0].wrappedStates[0].wrappedOptions[0]
        return CombinationView(option: option)
            .environmentObject(AlgorithmViewModel())
    }
}

extension CombinationView {
    private var combinationElements: some View {
        ForEach(option.wrappedCombinations) { combination in
            NavigationLink {
                CombinationSettings(combination: combination, tape: combination.option.state.algorithm.wrappedTapes[Int(combination.id)])
            } label: {
                HStack {
                    
                    Text(combination.character)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Image(systemName: combination.directionID == 0
                          ? "arrow.counterclockwise"
                          : combination.directionID == 1 ? "arrow.left" : "arrow.right"
                    )
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Text(combination.toCharacter)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        
                    Divider()
                    Text("Tape \(combination.option.state.algorithm.wrappedTapes[Int(combination.id)].nameID)")
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
    
}
