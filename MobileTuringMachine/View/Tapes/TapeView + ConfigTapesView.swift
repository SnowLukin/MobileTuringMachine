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
                            ConfigTapesView(tape: tape)
                                .padding(.bottom)
                        }
                        configButton
                            .padding(.trailing, 10)
                            .padding(.bottom, 5)
                    }
                }
                TapeView(tape: tape)
            }.padding(.horizontal)
        }
    }
    
}

struct TapeViewConfigTapesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        let algorithm = DataManager.shared.savedAlgorithms[0]
        return TapeViewConfigTapesView(tape: algorithm.wrappedTapes[0])
            .environmentObject(AlgorithmViewModel())
    }
}

extension TapeViewConfigTapesView {
    
    private var removeButton: some View {
        Button {
            withAnimation {
                viewModel.deleteTape(tape)
            }
        } label: {
            Text("Remove")
                .animation(.easeInOut, value: !isConfigShown)
        }
        .disabled(tape.algorithm.wrappedTapes.count < 2)
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
