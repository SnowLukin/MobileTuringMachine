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
            ForEach(viewModel.states) { state in
                Button {
                    viewModel.changeStartState(to: state)
                } label: {
                    HStack {
                        Text("State \(state.nameID)")
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.getStartState() == state {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        }
                    }
                }
                .buttonStyle(NoTapColorButtonStyle())
            }
        }
        .navigationTitle("Current state")
    }
}

struct ChooseStartStateView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseStartStateView()
            .environmentObject(TapeContentViewModel())
    }
}
