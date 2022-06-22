//
//  TapeView + ConfigTapesView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeViewConfigTapesView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var isConfigShown = false
    
    let tape: Tape
    let algorithm: Algorithm
    
    var body: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 0) {
                ZStack {
                    HStack {
                        if !isConfigShown {
                            removeButton
                            Spacer()
                        }
                        if isConfigShown {
                            ConfigTapesView(tape: tape, algorithm: algorithm)
                                .padding(.bottom)
                        }
                        configButton
                            .padding(.trailing, 10)
                            .padding(.bottom, 5)
                    }
                }
                TapeView(tape: tape, algorithm: algorithm)
            }.padding(.horizontal)
        }
    }
    
}

struct TapeViewConfigTapesView_Previews: PreviewProvider {
    static var previews: some View {
        TapeViewConfigTapesView(tape: Tape(nameID: 0, components: [TapeContent(id: 0)]), algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])))
            .preferredColorScheme(.dark)
            .environmentObject(AlgorithmViewModel())
    }
}

extension TapeViewConfigTapesView {
    
    private var removeButton: some View {
        Button {
            withAnimation {
                viewModel.removeTape(tape: tape, from: algorithm)
            }
        } label: {
            Text("Remove")
                .animation(.easeInOut, value: !isConfigShown)
        }
        .disabled(viewModel.getAlgorithm(algorithm).tapes.count < 2)
    }
    
    private var configButton: some View {
        Button {
            withAnimation(.default) {
                isConfigShown.toggle()
            }
        } label: {
            ZStack {
                Color.secondaryBackground
                Image(systemName: !isConfigShown ? "plus" : "xmark")
                    .font(.title3)
            }
            .frame(width: 30, height: 30)
            .clipShape(Circle())
        }
    }
    
}
