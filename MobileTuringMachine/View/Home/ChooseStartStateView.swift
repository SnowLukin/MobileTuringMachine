//
//  ChooseStartStateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct ChooseStartStateView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        List {
            ForEach(0..<viewModel.states.count, id: \.self) { stateIndex in
                Button {
                    viewModel.startState = stateIndex
                } label: {
                    HStack {
                        Text("State \(stateIndex)")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(viewModel.startState == stateIndex ? 1 : 0)
                    }
                }
            }
        }
        .navigationTitle("Choose Start State")
    }
}

struct ChooseStartStateView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseStartStateView()
            .environmentObject(TapeContentViewModel())
    }
}
