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
            ForEach(algorithm.wrappedTapes) { tape in
                TapeSectionOpening(tape: tape)
            }
        }
        .navigationTitle("Tapes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        viewModel.addTape(algorithm: algorithm)
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
        let algorithm = DataManager.shared.savedAlgorithms[0]
        Tapes(algorithm: algorithm)
            .environmentObject(AlgorithmViewModel())
    }
}
