//
//  CombinationView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct CombinationView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    let stateID: Int
    let optionID: Int
    
    var body: some View {
        List {
            ForEach(0..<viewModel.states[stateID].options[optionID].combinationsTuple.count, id: \.self) { elementIndex in
                NavigationLink {
                    CombinationSettings(stateID: stateID, optionID: optionID, elementID: elementIndex)
                } label: {
                    HStack {
                        
                        Text("\(viewModel.states[stateID].options[optionID].combinationsTuple[elementIndex].character)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "\(viewModel.states[stateID].options[optionID].combinationsTuple[elementIndex].direction.rawValue)")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                        
                        Text("\(viewModel.states[stateID].options[optionID].combinationsTuple[elementIndex].toCharacter)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            
                        Divider()
                        Text("Tape \(elementIndex)")
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
        .navigationBarTitle("Combination: \(viewModel.states[stateID].options[optionID].combinationsTuple.map { $0.character }.joined(separator: ""))")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationView_Previews: PreviewProvider {
    static var previews: some View {
        CombinationView(stateID: 0, optionID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
