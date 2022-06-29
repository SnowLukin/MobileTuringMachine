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
            ForEach(algorithm.wrappedTapes) { tape in
                VStack(spacing: 0) {
                    setTapeNameText(tapeID: Int(tape.nameID))
                    TapeView(tape: tape)
                        .padding([.leading, .trailing])
                }
            }
        }
    }
}

struct TapesWorkView_Previews: PreviewProvider {
    static var previews: some View {
        let algorithm = DataManager.shared.savedAlgorithms[0]
        TapesWorkView(algorithm: algorithm)
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
