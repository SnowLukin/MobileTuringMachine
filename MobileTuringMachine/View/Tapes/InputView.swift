//
//  InputView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct InputView: View {
    
    enum Purpose {
        case alphabet
        case input
    }
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var text = ""
    
    let tape: Tape
    let purpose: Purpose
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textfieldName
            textfield
        }
        .onAppear {
            text = purpose == .alphabet ? tape.alphabet : tape.input
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        let algorithm = DataManager.shared.savedAlgorithms[0]
        
        return InputView(tape: algorithm.wrappedTapes[0], purpose: .alphabet)
            .environmentObject(AlgorithmViewModel())
            .padding()
    }
}

extension InputView {
    
    private var textfieldName: some View {
        Text(purpose == .alphabet ? "Alphabet" : "Input")
            .fontWeight(.semibold)
    }
    
    private var textfield: some View {
        TextField("", text: $text)
            .font(.title3.bold())
            .frame(height: 30)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            .background(Color.secondaryBackground)
            .cornerRadius(12)
            .onChange(of: text) { _ in
                if purpose == .alphabet {
                    viewModel.setNewAlphabetValue(text, for: tape)
                } else {
                    viewModel.setNewInputValue(text, for: tape)
                }
            }
            .onChange(of: tape.alphabet) { newValue in
                if purpose == .alphabet {
                    text = newValue
                }
            }
            .onChange(of: tape.input) { newValue in
                if purpose == .input {
                    text = newValue
                }
            }
    }
}
