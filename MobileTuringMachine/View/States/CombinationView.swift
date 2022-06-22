//
//  CombinationView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let algorithm: Algorithm
    let state: StateQ
    let option: Option
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    ChooseStateView(algorithm: algorithm, state: state, option: option)
                } label: {
                    Text("Navigate to:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("State \(viewModel.getOptionToState(algorithm: algorithm, state: state, option: option))")
                        .foregroundColor(.gray)
                }
            }
            Section(header: Text("Elements rewriting")) {
                combinationElements
            }
        }
        .navigationBarTitle(
            "Combination: \(option.combinations.map { $0.character }.joined(separator: ""))"
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationView_Previews: PreviewProvider {
    static var previews: some View {
        CombinationView(
            algorithm:
                Algorithm(
                    name: "New Algorithm",
                    tapes: [],
                    states: [],
                    stateForReset: StateQ(nameID: 0, options: [])
                ),
            state: StateQ(nameID: 0, options: []),
            option: Option(
                toState: StateQ(nameID: 0, options: []),
                combinations: [Combination(character: "a", direction: .stay, toCharacter: "a")]
            )
        )
        .environmentObject(AlgorithmViewModel())
    }
}

extension CombinationView {
    private var combinationElements: some View {
        ForEach(option.combinations) { combination in
            NavigationLink {
                CombinationSettings(
                    algorithm: algorithm,
                    tape: viewModel.getMatchingTape(
                        algorithm: algorithm,
                        state: state,
                        option: option,
                        combination: combination
                    ),
                    state: state,
                    option: option,
                    combination: combination
                )
            } label: {
                HStack {
                    
                    Text(viewModel.getCombination(algorithm: algorithm, state: state, option: option, combination: combination)?.character ?? "Error")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Image(systemName: viewModel.getCombination(algorithm: algorithm, state: state, option: option, combination: combination)?.direction.rawValue ?? Direction.stay.rawValue)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Text(viewModel.getCombination(algorithm: algorithm, state: state, option: option, combination: combination)?.toCharacter ?? "Error")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        
                    Divider()
                    Text("Tape \(viewModel.getMatchingTape(algorithm: algorithm, state: state, option: option, combination: combination).nameID)")
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
    
}
