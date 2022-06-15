//
//  TapesWorkView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct TapesWorkView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.tapes) { tape in
                VStack(spacing: 0) {
                    setTapeTag(tapeID: tape.nameID)
                    TapeView(tape: tape)
                        .padding([.leading, .trailing])
                }
            }
        }
    }
}

struct TapesWorkView_Previews: PreviewProvider {
    static var previews: some View {
        TapesWorkView()
            .environmentObject(TapeContentViewModel())
    }
}

extension TapesWorkView {
    private func setTapeTag(tapeID: Int) -> some View {
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
