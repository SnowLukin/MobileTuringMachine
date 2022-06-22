//
//  ConfigTapesView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct ConfigTapesView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let tape: Tape
    let algorithm: Algorithm
    
    var body: some View {
        VStack {
            VStack {
                InputView(tape: tape, algorithm: algorithm, purpose: .alphabet)
                InputView(tape: tape, algorithm: algorithm, purpose: .input)
            }
            .padding()
            .background(Color.background)
            .cornerRadius(20)
        }
    }
}

struct ConfigTapesView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigTapesView(tape: Tape(nameID: 0, components: [TapeContent(id: 0)]), algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])))
            .preferredColorScheme(.dark)
            .environmentObject(AlgorithmViewModel())
    }
}
