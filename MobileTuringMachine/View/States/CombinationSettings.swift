//
//  CombinationSettings.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationSettings: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let tape: Tape
    let state: StateQ
    let option: Option
    let combination: Combination
    
    var body: some View {
        Form {
            characterSection
            directionSection
        }

        .navigationBarTitle("Tape \(tape.nameID) | Character: \(combination.character)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationSettings_Previews: PreviewProvider {
    static var previews: some View {
        CombinationSettings(
            tape: Tape(nameID: 0, components: []),
            state: StateQ(nameID: 0, options: []),
            option: Option(toState: StateQ(nameID: 0, options: []), combinations: []),
            combination: Combination(character: "_", direction: .stay, toCharacter: "_")
        ).environmentObject(TapeContentViewModel())
    }
}


extension CombinationSettings {
    
    private var characterSection: some View {
        Section(header: Text("Change to following character")) {
            NavigationLink {
                ChooseCharView(tape: tape, state: state, option: option, combination: combination)
            } label: {
                HStack {
                    Text("Alphabet")
                    Spacer()
                    Text(viewModel.getCombination(state: state, option: option, combination: combination)?.toCharacter ?? "Error")
                }
            }
        }
    }
    
    private var directionSection: some View {
        Section(header: Text("Move tape's head to following direction")) {
            NavigationLink {
                ChooseDirectionView(tape: tape, state: state, option: option, combination: combination)
            } label: {
                HStack {
                    Text("Direction")
                    Spacer()
                    Image(
                        systemName:
                            viewModel.getCombination(
                                state: state,
                                option: option,
                                combination: combination
                            )?.direction.rawValue
                        ?? Direction.stay.rawValue
                    )
                }
            }
        }
    }
}
