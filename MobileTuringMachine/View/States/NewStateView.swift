//
//  NewStateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct NewStateView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        NavigationView {
            CustomVerticalGrid(
                columns: 3,
                items: Array(0...viewModel.states.count)) { itemSize, itemIndex in
                    NavigationLink(destination: CombinationsListView(stateID: itemIndex)) {
                        StateView(stateID: itemIndex)
                            .frame(width: itemSize)
                    }
                }
                .padding()
                .navigationTitle("States")
        }
    }
}

struct NewStateView_Previews: PreviewProvider {
    static var previews: some View {
        NewStateView()
            .environmentObject(TapeContentViewModel())
    }
}
