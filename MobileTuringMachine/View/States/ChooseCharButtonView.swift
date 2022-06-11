//
//  ChooseCharButtonView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 11.06.2022.
//

import SwiftUI

struct ChooseCharButtonView: View {
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var isChosen: Bool = false
    
    let tapeID: Int
    let stateID: Int
    let optionID: Int
    let alphabetElementIndex: Int
    
    var body: some View {
        Button {
            withAnimation {
                isChosen = true
            }
            viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].toCharacter = viewModel.tapes[tapeID].alphabetArray[alphabetElementIndex]
        } label : {
            HStack {
                Text(viewModel.tapes[tapeID].alphabetArray[alphabetElementIndex])
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "circle.fill")
                    .opacity(
                        isChosen ? 1 : 0
                    )
                    .foregroundColor(.blue)
            }
        }
        .onAppear {
            if viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].toCharacter == viewModel.tapes[tapeID].alphabetArray[alphabetElementIndex] {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isChosen = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isChosen = false
                }
            }
        }
        .onChange(of: viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].toCharacter) { _ in
            if viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].toCharacter == viewModel.tapes[tapeID].alphabetArray[alphabetElementIndex] {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isChosen = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isChosen = false
                }
            }
        }
        .buttonStyle(NoTapColorButtonStyle())
    }
}

struct ChooseCharButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCharButtonView(tapeID: 0, stateID: 0, optionID: 0, alphabetElementIndex: 0)
    }
}
