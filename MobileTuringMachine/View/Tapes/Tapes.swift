//
//  Tapes.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct Tapes: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    let algorithm: Algorithm
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.getAlgorithm(algorithm).tapes) { tape in
                TapeSectionOpening(tape: tape, algorithm: algorithm)
            }
        }
        .navigationTitle("Tapes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        viewModel.addTape(to: algorithm)
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct Tapes_Previews: PreviewProvider {
    static var previews: some View {
        Tapes(algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])))
            .environmentObject(AlgorithmViewModel())
    }
}
