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
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    @State private var text = ""
    
    let tapeID: Int
    
    let purpose: Purpose
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textfieldName
            textfield
        }
        .onAppear {
            text = purpose == .alphabet ? viewModel.tapes[tapeID].alphabet : viewModel.tapes[tapeID].input
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(tapeID: 0, purpose: .alphabet)
            .environmentObject(TapeContentViewModel())
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
            viewModel.setNewInput(text, id: tapeID)
            return
        }
        
        // if new character is "space" change it to "_"
        if lastCharacter == " " {
            text.append("_")
            viewModel.setNewInput(text, id: tapeID)
            return
        }
        // if there is such character in alphabet - save it
        // otherwise delete it
        if viewModel.tapes[tapeID].alphabet.contains(lastCharacter) {
            text.append(lastCharacter)
        }
        viewModel.setNewInput(text, id: tapeID)
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
        viewModel.setNewAlphabet(text, id: tapeID)
    }
}
