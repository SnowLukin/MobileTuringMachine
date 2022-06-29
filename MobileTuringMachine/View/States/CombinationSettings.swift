//
//  CombinationSettings.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationSettings: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let combination: Combination
    let tape: Tape
    
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
        let algorithm = DataManager.shared.savedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        let combination = algorithm.wrappedStates[0].wrappedOptions[0].wrappedCombinations[0]
        
        CombinationSettings(combination: combination, tape: tape)
            .environmentObject(AlgorithmViewModel())
    }
}


extension CombinationSettings {
    
    private var characterSection: some View {
        Section(header: Text("Change to following character")) {
            NavigationLink {
                ChooseCharView(combination: combination, tape: tape)
            } label: {
                HStack {
                    Text("Alphabet")
                    Spacer()
                    Text(combination.toCharacter)
                }
            }
        }
    }
    
    private var directionSection: some View {
        Section(header: Text("Move tape's head to following direction")) {
            NavigationLink {
                ChooseDirectionView(combination: combination)
            } label: {
                HStack {
                    Text("Direction")
                    Spacer()
                    Image(systemName:
                            combination.directionID == 0
                          ? "arrow.counterclockwise"
                          : combination.directionID == 1 ? "arrow.left" : "arrow.right"
                    )
                }
            }
        }
    }
}
