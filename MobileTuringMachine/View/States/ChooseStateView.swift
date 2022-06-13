//
//  ChooseStateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 11.06.2022.
//

import SwiftUI

struct ChooseStateView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    let stateID: Int
    let optionID: Int
    
    var body: some View {
        List {
            ForEach(0..<viewModel.states.count) { currentStateID in
                Button {
                    viewModel.states[stateID].options[optionID].toStateID = currentStateID
                } label: {
                    HStack {
                        Text("State \(currentStateID)")
                            .foregroundColor(.primary)
                        Spacer()
                        if viewModel.states[stateID].options[optionID].toStateID == currentStateID {
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
        ChooseStateView(stateID: 0, optionID: 0)
            .environmentObject(TapeContentViewModel())
    }
}

struct ChooseStateButtonView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var isChosen: Bool = false
    
    let stateID: Int
    let currentStateID: Int
    let optionID: Int
    
    var body: some View {
        Button {
            viewModel.states[stateID].options[optionID].toStateID = currentStateID
        } label: {
            HStack {
                Text("State \(currentStateID)")
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "circle.fill")
                    .foregroundColor(.blue)
                    .opacity(isChosen ? 1 : 0)
            }
        }
        .buttonStyle(NoTapColorButtonStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                if viewModel.states[stateID].options[optionID].toStateID == currentStateID {
                    isChosen = true
                } else {
                    isChosen = false
                }
            }
        }
        .onChange(of: viewModel.states[stateID].options[optionID].toStateID) { newValue in
            withAnimation(.easeInOut(duration: 0.2)) {
                if newValue == currentStateID {
                    isChosen = true
                } else {
                    isChosen = false
                }
            }
        }
        
    }
    
}
