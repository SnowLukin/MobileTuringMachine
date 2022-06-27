//
//  CombinationsListView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationsListView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let state: StateQ
    
    var body: some View {
        List {
            ForEach(state.wrappedOptions) { option in
                NavigationLink {
                    CombinationView(option: option)
                } label: {
                    Text("\(option.wrappedCombinations.map { $0.character }.joined(separator: ""))")
                }
            }
        }
        .navigationTitle("State \(state.nameID)'s combinations")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationsListView_Previews: PreviewProvider {
    static var previews: some View {
        let state = DataManager.shared.savedAlgorithms[0].wrappedStates[0]
        CombinationsListView(state: state)
            .environmentObject(AlgorithmViewModel())
    }
}
