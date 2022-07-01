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
    
    var body: some View {
        VStack {
            VStack {
                InputView(tape: tape, purpose: .alphabet)
                InputView(tape: tape, purpose: .input)
            }
            .padding()
            .background(Color.background)
            .cornerRadius(20)
        }
    }
}

struct ConfigTapesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        let algorithm = DataManager.shared.savedAlgorithms[0]
        return ConfigTapesView(tape: algorithm.wrappedTapes[0])
            .environmentObject(AlgorithmViewModel())
    }
}
