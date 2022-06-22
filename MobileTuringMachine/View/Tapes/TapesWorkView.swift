//
//  TapesWorkView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct TapesWorkView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let algorithm: Algorithm
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.getAlgorithm(algorithm).tapes) { tape in
                VStack(spacing: 0) {
                    setTapeNameText(tapeID: tape.nameID)
                    TapeView(tape: tape, algorithm: algorithm)
                        .padding([.leading, .trailing])
                }
            }
        }
    }
}

struct TapesWorkView_Previews: PreviewProvider {
    static var previews: some View {
        TapesWorkView(algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])))
            .environmentObject(AlgorithmViewModel())
    }
}

extension TapesWorkView {
    private func setTapeNameText(tapeID: Int) -> some View {
        HStack {
            Text("Tape \(tapeID)")
                .padding([.leading, .trailing])
                .background(
                    RoundedCornersBackground(corners: [.topLeft, .topRight], radius: 6)
                        .fill(Color.secondaryBackground)
                )
                .padding([.leading], 8)
            Spacer()
        }.padding(.leading)
    }
}
