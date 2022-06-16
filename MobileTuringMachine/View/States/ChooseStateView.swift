//
//  ChooseStateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 11.06.2022.
//

import SwiftUI

struct ChooseStateView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    let state: StateQ
    let option: OptionState
    
    var body: some View {
        List {
            ForEach(viewModel.states) { currentState in
                Button {
                    viewModel.updateOptionToState(
                        state: state,
                        option: option,
                        currentState: currentState
                    )
                } label: {
                    HStack {
                        Text("State \(currentState.nameID)")
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.isChosenToState(
                            state: state,
                            option: option,
                            currentState: currentState
                        ) {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .transition(
                                    AnyTransition.opacity.animation(
                                        .easeInOut(duration: 0.2)
                                    )
                                )
                        }
                    }
                }.buttonStyle(NoTapColorButtonStyle())
            }
        }
    }
}

struct ChooseStateView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseStateView(state: StateQ(nameID: 0, options: []), option: OptionState(toState: StateQ(nameID: 0, options: []), combinations: []))
            .environmentObject(TapeContentViewModel())
    }
}
