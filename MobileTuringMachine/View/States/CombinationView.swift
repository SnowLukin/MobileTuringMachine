//
//  CombinationView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let state: StateQ
    let option: Option
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    ChooseStateView(state: state, option: option)
                } label: {
                    Text("Navigate to:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("State \(viewModel.getOptionToState(state: state, option: option))")
                        .foregroundColor(.gray)
                }
            }
            Section(header: Text("Elements rewriting")) {
                combinationElements
            }
        }
        .navigationBarTitle(
            "Combination: \(option.combinations.map { $0.character }.joined(separator: ""))"
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationView_Previews: PreviewProvider {
    static var previews: some View {
        CombinationView(
            state: StateQ(
                nameID: 0,
                options: []
            ),
            option: Option(
                toState: StateQ(nameID: 0, options: []),
                combinations: [Combination(character: "a", direction: .stay, toCharacter: "a")]
            )
        )
        .environmentObject(TapeContentViewModel())
    }
}

extension CombinationView {
    private var combinationElements: some View {
        ForEach(option.combinations) { combination in
            NavigationLink {
                CombinationSettings(
                    tape: viewModel.getMatchingTape(
                        state: state,
                        option: option,
                        combination: combination
                    ),
                    state: state,
                    option: option,
                    combination: combination
                )
            } label: {
                HStack {
                    
                    Text(viewModel.getCombination(state: state, option: option, combination: combination)?.character ?? "Error")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Image(systemName: viewModel.getCombination(state: state, option: option, combination: combination)?.direction.rawValue ?? Direction.stay.rawValue)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Text(viewModel.getCombination(state: state, option: option, combination: combination)?.toCharacter ?? "Error")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        
                    Divider()
                    Text("Tape \(viewModel.getMatchingTape(state: state, option: option, combination: combination).nameID)")
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
    
}
