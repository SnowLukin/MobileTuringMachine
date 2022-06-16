//
//  CombinationsListView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationsListView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    let state: StateQ
    
    var body: some View {
        List {
            ForEach(state.options) { option in
                NavigationLink {
                    CombinationView(state: state, option: option)
                } label: {
                    Text("\(option.combinations.map { $0.character }.joined(separator: ""))")
                }

            }
        }
        .navigationTitle("State \(state.nameID)")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationsListView_Previews: PreviewProvider {
    static var previews: some View {
        CombinationsListView(state: StateQ(nameID: 0, options: []))
            .environmentObject(TapeContentViewModel())
    }
}
