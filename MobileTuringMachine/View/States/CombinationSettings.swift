//
//  CombinationSettings.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationSettings: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var charIndex = 0
    @State private var directionIndex = 0
    
    let stateID: Int
    let optionID: Int
    let elementID: Int
    
    var body: some View {
        Form {
            Section(header: Text("Change to following character")) {
                Picker(selection: $charIndex) {
                    ForEach(0..<viewModel.tapes[elementID].alphabetArray.count, id: \.self) { alphabetElementIndex in
                        
                        Text(viewModel.tapes[elementID].alphabetArray[alphabetElementIndex])
                            .tag(alphabetElementIndex)
                    }
                } label: {
                    Text("Alphabet")
                }
                .onAppear {
                    let currentChar = viewModel.states[stateID].options[optionID].combinationsTuple[elementID].toCharacter
                    let currentCharIndexInTape = Int(viewModel.tapes[elementID].alphabetArray.firstIndex(of: currentChar) ?? 0)
                    charIndex = currentCharIndexInTape
                }
                .onChange(of: charIndex) { newValue in
                    let newChar = viewModel.tapes[elementID].alphabetArray[newValue]
                    viewModel.states[stateID].options[optionID].combinationsTuple[elementID].toCharacter = newChar
                }
            }
            
            Section(header: Text("Move tape's head to following direction")) {
                Picker(selection: $directionIndex) {
                    Image(systemName: "arrow.counterclockwise").tag(0)
                    Image(systemName: "arrow.left").tag(1)
                    Image(systemName: "arrow.right").tag(2)
                } label: {
                    Text("Direction")
                }
                .onAppear {
                    let currentDirection = viewModel.states[stateID].options[optionID].combinationsTuple[elementID].direction
                    switch currentDirection {
                    case .stay:
                        directionIndex = 0
                    case .left:
                        directionIndex = 1
                    case .right:
                        directionIndex = 2
                    }
                }
                .onChange(of: directionIndex) { newValue in
                    let newDirection: Direction = newValue == 0 ? .stay : newValue == 1 ? .left : .right
                    viewModel.states[stateID].options[optionID].combinationsTuple[elementID].direction = newDirection
                }
            }
        }
        .navigationBarTitle("Tape \(elementID) | Character: \(viewModel.states[stateID].options[optionID].combinationsTuple.map { $0.character }[elementID])")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationSettings_Previews: PreviewProvider {
    static var previews: some View {
        CombinationSettings(stateID: 0, optionID: 0, elementID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
