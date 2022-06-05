//
//  StateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.06.2022.
//

import SwiftUI

struct StateView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var showPopup = false
    @State private var size = CGSize()
    
    let stateId: Int
    
    var body: some View {
        NavigationView {
            Button {
                withAnimation {
                    showPopup.toggle()
                }
            } label: {
                Text("State \(stateId)")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primary)
                    .padding()
            }
            .background(Color.secondaryBackground)
            .cornerRadius(12)
        }
        
        .popupNavigationView(horizontalPadding: 40, show: $showPopup) {
            List {
                ForEach(0..<viewModel.states[stateId].options.count, id: \.self) { optionIndex in
                    Menu {
                        ForEach(0..<viewModel.states[stateId].options[optionIndex].combinationsTuple.count, id: \.self) { combinationTupleIndex in
                            
                            Menu {
                                setAlphabetSection(
                                    optionIndex: optionIndex,
                                    combinationTupleIndex: combinationTupleIndex
                                )
                                
                                setImageSection(
                                    optionIndex: optionIndex,
                                    combinationTupleIndex: combinationTupleIndex
                                )
                            } label: {
                                setCombinationTupleLabel(
                                    optionIndex: optionIndex,
                                    combinationTupleIndex: combinationTupleIndex
                                )
                            }
                        }
                        Menu {
                            setPossibleStates(optionIndex: optionIndex)
                        } label: {
                            Text("State \(viewModel.states[stateId].options[optionIndex].toStateID)")
                        }
                    } label: {
                        setCombinationView(
                            combination: viewModel.states[stateId].options[optionIndex].combinations.joined(separator:"")
                        )
                    }
                    .frame(width: size.width / 1.32)
                }
            }.readSize(onChange: { subSize in
                size = subSize
            })
            .navigationBarTitle("State \(stateId)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        withAnimation {
                            showPopup.toggle()
                        }
                    }
                }
            }
        }
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView(stateId: 0)
            .environmentObject(TapeContentViewModel())
    }
}

extension StateView {
    private func setCombinationView(combination: String) -> some View {
        HStack {
            ForEach(combination.map { String($0) }, id: \.self) { letter in
                Text(letter)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .frame(height: 30)
            }
            .frame(width: 30)
        }
    }
    
    private func setPossibleStates(optionIndex: Int) -> some View {
        ForEach(0..<viewModel.states.count, id: \.self) { stateIndex in
            Button {
                viewModel.states[stateId].options[optionIndex].toStateID = stateIndex
            } label: {
                Text("State \(stateIndex)")
            }
        }
    }
    
    private func setCombinationTupleLabel(optionIndex: Int, combinationTupleIndex: Int) -> some View {
        Label(
            "\(viewModel.states[stateId].options[optionIndex].combinationsTuple[combinationTupleIndex].character)",
            systemImage: viewModel.states[stateId].options[optionIndex].combinationsTuple[combinationTupleIndex].direction.rawValue
        )
    }
    
    private func setAlphabetSection(optionIndex: Int, combinationTupleIndex: Int) -> some View {
        Section(header: Text("Change element to")) {
            ForEach(viewModel.tapes[combinationTupleIndex].alphabetArray, id: \.self) { possibleElement in
                Button {
                    viewModel.states[stateId].options[optionIndex].combinationsTuple[combinationTupleIndex].character = possibleElement
                } label: {
                    Text("\(possibleElement)")
                }
            }
        }
    }
    
    private func setImageSection(optionIndex: Int, combinationTupleIndex: Int) -> some View {
        Section(header: Text("Change direction to")) {
            Button {
                viewModel.states[stateId].options[optionIndex].combinationsTuple[combinationTupleIndex].direction = .stay
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }

            Button {
                viewModel.states[stateId].options[optionIndex].combinationsTuple[combinationTupleIndex].direction = .left
            } label: {
                Image(systemName: "arrow.left")
            }

            Button {
                viewModel.states[stateId].options[optionIndex].combinationsTuple[combinationTupleIndex].direction = .right
            } label: {
                Image(systemName: "arrow.right")
            }
        }
    }
}
