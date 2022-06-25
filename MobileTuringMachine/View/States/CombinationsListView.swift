//
//  CombinationsListView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationsListView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let algorithm: Algorithm
    let state: StateQ
    
    var body: some View {
        List {
            ForEach(state.options) { option in
                NavigationLink {
                    CombinationView(algorithm: algorithm, state: state, option: option)
                } label: {
                    Text("\(option.combinations.map { $0.character }.joined(separator: ""))")
                }
            }
        }
        .navigationTitle("State \(state.nameID)'s combinations")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationsListView_Previews: PreviewProvider {
    static var previews: some View {
        CombinationsListView(
            algorithm:
                Algorithm(
                    name: "New Algorithm",
                    tapes: [],
                    states: [],
                    stateForReset: StateQ(nameID: 0, options: [])
                ),
            state: StateQ(
                nameID: 0,
                options: [
                    Option(
                        id: 0, toState: StateQ(nameID: 0, options: []),
                        combinations: [
                            Combination(
                                id: 0,
                                character: "a",
                                direction: .stay,
                                toCharacter: "a"
                            )
                        ]
                    )
                ]
            )
        )
        .environmentObject(AlgorithmViewModel())
    }
}
