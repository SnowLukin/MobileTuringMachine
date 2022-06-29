//
//  InfoView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI

struct InfoView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    @FocusState private var nameIsFocused: Bool
    @FocusState private var descriptionIsFocused: Bool
    @State private var name: String = ""
    @State private var description: String = ""
    
    let algorithm: Algorithm
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Placeholder", text: $name)
                    .focused($nameIsFocused)
            }
            
            Section("Description") {
                ZStack {
                    TextEditor(text: $description)
                        .focused($descriptionIsFocused)
                    Text(description).opacity(0).padding(.all, 8)
                }
            }
            .onAppear {
                name = algorithm.name
                description = algorithm.algorithmDescription
            }
        }
        .onChange(of: name) { newValue in
            if name.count > 20 {
                name.removeLast()
            }
            viewModel.updateName(with: name, for: algorithm)
        }
        .onChange(of: description) { newValue in
            viewModel.updateDescription(with: description, for: algorithm)
        }
    }
    
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(
            algorithm: DataManager.shared.savedAlgorithms[0]
        )
        .environmentObject(AlgorithmViewModel())
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
