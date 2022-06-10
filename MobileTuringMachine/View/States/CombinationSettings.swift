//
//  CombinationSettings.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationSettings: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let stateID: Int
    let optionID: Int
    let elementID: Int
    
    var body: some View {
        Form {
            characterSection
            directionSection
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


extension CombinationSettings {
    
    private var characterSection: some View {
        Section(header: Text("Change to following character")) {
            NavigationLink {
                ChooseCharView(tapeID: elementID, stateID: stateID, optionID: optionID)
            } label: {
                HStack {
                    Text("Alphabet")
                    Spacer()
                    Text(viewModel.states[stateID].options[optionID].combinationsTuple[elementID].toCharacter)
                }
            }
        }
    }
    
    private var directionSection: some View {
        Section(header: Text("Move tape's head to following direction")) {
            NavigationLink {
                ChooseCharView(tapeID: elementID, stateID: stateID, optionID: optionID)
            } label: {
                HStack {
                    Text("Direction")
                    Spacer()
                    Image(systemName: viewModel.states[stateID].options[optionID].combinationsTuple[elementID].direction.rawValue)
                }
            }
        }
    }
}
