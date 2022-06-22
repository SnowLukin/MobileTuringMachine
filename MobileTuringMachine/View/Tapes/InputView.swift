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
    let algorithm: Algorithm
    let purpose: Purpose
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textfieldName
            textfield
        }
        .onAppear {
            let tapeVM = viewModel.getTape(tape: tape, of: algorithm)
            text = purpose == .alphabet ? tapeVM.alphabet : tapeVM.input
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(tape: Tape(nameID: 0, components: [TapeContent(id: 0)]), algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])), purpose: .alphabet)
            .environmentObject(AlgorithmViewModel())
            .padding()
            .preferredColorScheme(.dark)
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
                purpose == .alphabet
                ? setNewAlphabetValue()
                : setNewInputValue()
            }
    }
    
    private func setNewInputValue() {
        // if not last
        guard let lastCharacter = text.popLast() else {
            viewModel.setNewInput(text, tape: tape, algorithm: algorithm)
            return
        }
        
        // if new character is "space" change it to "_"
        if lastCharacter == " " {
            text.append("_")
            viewModel.setNewInput(text, tape: tape, algorithm: algorithm)
            return
        }
        // if there is such character in alphabet - save it
        // otherwise delete it
        if viewModel.getTape(tape: tape, of: algorithm).alphabet.contains(lastCharacter) {
            text.append(lastCharacter)
        }
        viewModel.setNewInput(text, tape: tape, algorithm: algorithm)
    }
    
    private func setNewAlphabetValue() {
        if text.isEmpty {
            return
        }
        // Checking new character already exist
        // if it is - delete it
        if let lastCharacter = text.popLast() {
            if lastCharacter == " " {
                return
            } else if !text.contains(lastCharacter) {
                text.append(String(lastCharacter))
            }
        }
        viewModel.setNewAlphabet(text, tape: tape, algorithm: algorithm)
    }
}
