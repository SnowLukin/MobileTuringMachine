//
//  CombinationsListView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationsListView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    let stateID: Int
    
    var body: some View {
        List {
            ForEach(0..<viewModel.states[stateID].options.count, id: \.self) { optionID in
                NavigationLink {
                    CombinationView(stateID: stateID, optionID: optionID)
                } label: {
                    Text("\(viewModel.states[stateID].options[optionID].combinationsTuple.map { $0.character }.joined(separator: ""))")
                }

            }
        }
            .navigationTitle("State \(stateID)")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationsListView_Previews: PreviewProvider {
    static var previews: some View {
        CombinationsListView(stateID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
