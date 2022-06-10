//
//  ChooseDirectionView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 10.06.2022.
//

import SwiftUI

struct ChooseDirectionView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    
    let tapeID: Int
    let stateID: Int
    let optionID: Int
    
    var body: some View {
        
        // TODO: - Make it less code
        Form {
            Button {
                viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction = .stay
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "circle.fill")
                        .foregroundColor(.blue)
                        .opacity(
                            viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction == .stay ? 1 : 0
                        )
                }
            }
            
            Button {
                viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction = .left
            } label: {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "circle.fill")
                        .foregroundColor(.blue)
                        .opacity(
                            viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction == .left ? 1 : 0
                        )
                }
            }
            
            Button {
                viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction = .right
            } label: {
                HStack {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "circle.fill")
                        .foregroundColor(.blue)
                        .opacity(
                            viewModel.states[stateID].options[optionID].combinationsTuple[tapeID].direction == .right ? 1 : 0
                        )
                }
            }
        }
        .navigationTitle("Choose direction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseDirectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDirectionView(tapeID: 0, stateID: 0, optionID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
