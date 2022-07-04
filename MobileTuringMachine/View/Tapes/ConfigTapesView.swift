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
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        for algorithm in folder.wrappedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm(to: folder)
        let algorithm = folder.wrappedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        
        return ConfigTapesView(tape: tape)
            .environmentObject(AlgorithmViewModel())
    }
}
