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
    
    var layout: [GridItem] = [
        GridItem(.flexible(minimum: 25))
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                tapeGrid
                    .onAppear {
                        withAnimation {
                            value.scrollTo(tape.headIndex, anchor: .center)
                        }
                    }
                    .onChange(of: tape.headIndex) { newValue in
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
        let viewModel = AlgorithmViewModel()
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        for algorithm in folder.wrappedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm(to: folder)
        let algorithm = folder.wrappedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        return TapeView(tape: tape)
            .environmentObject(AlgorithmViewModel())
            .padding()
    }
}


extension TapeView {
    
    private var tapeGrid: some View {
        LazyHGrid(rows: layout) {
            ForEach(tape.wrappedComponents) { component in
                TapeContentView(component: component)
            }
        }
        .padding(.horizontal)
    }
}
