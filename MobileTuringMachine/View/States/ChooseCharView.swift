//
//  ChooseCharView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 10.06.2022.
//

import SwiftUI

struct ChooseCharView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let tapeID: Int
    let stateID: Int
    let optionID: Int
    
    var body: some View {
        Form {
            ForEach(0..<viewModel.tapes[tapeID].alphabetArray.count, id: \.self) { alphabetElementIndex in
                ChooseCharButtonView(tapeID: tapeID, stateID: stateID, optionID: optionID, alphabetElementIndex: alphabetElementIndex)
            }
        }
        .navigationTitle("Choose character")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseCharView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCharView(tapeID: 0, stateID: 0, optionID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
