//
//  TapeView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let tape: Tape
    let algorithm: Algorithm
    
    var layout: [GridItem] = [
        GridItem(.flexible(minimum: 25))
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                tapeGrid
                    .onAppear {
                        withAnimation {
                            value.scrollTo(viewModel.getTape(tape: tape, of: algorithm).headIndex, anchor: .center)
                        }
                    }
                    .onChange(of: viewModel.getTape(tape: tape, of: algorithm).headIndex) { newValue in
                        withAnimation {
                            value.scrollTo(newValue, anchor: .center)
                        }
                    }
            }
        }
        .frame(height: 40)
        .background(Color.secondaryBackground)
        .cornerRadius(9)
    }
}

struct TapeView_Previews: PreviewProvider {
    static var previews: some View {
        TapeView(tape: Tape(nameID: 0, components: [TapeContent(id: 0)]), algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])))
            .environmentObject(AlgorithmViewModel())
            .preferredColorScheme(.dark)
            .padding()
    }
}


extension TapeView {
    
    private var tapeGrid: some View {
        LazyHGrid(rows: layout) {
            ForEach(tape.components) { component in
                TapeContentView(component: component, tape: tape, algorithm: algorithm)
            }
        }
        .padding(.horizontal)
    }
}
