//
//  StateHoneyGridCell.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 16.06.2022.
//

import SwiftUI

struct StateHoneyGridCell: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Binding var isBeingEdited: Bool
    
    let state: StateQ
    let algorithm: Algorithm
    
    var body: some View {
        NavigationLink {
            CombinationsListView(algorithm: algorithm, state: state)
        } label: {
            ZStack {
                Hexagon()
                    .fill(Color.secondaryBackground)
                HStack(spacing: 0) {
                    Text("Q")
                        .font(.title2)
                    Text("\(state.nameID)")
                        .font(.system(size: 15))
                }.foregroundColor(.primary)
            }
        }
        .shadow(radius: 5)
        .rotationEffect(.degrees(isBeingEdited ? 5 : 0), anchor: .center)
        .animation(
            isBeingEdited
            ? .easeInOut(duration: 0.12).repeatForever(autoreverses: true)
            : .easeInOut(duration: 0.12),
            value: isBeingEdited
        )
        .disabled(isBeingEdited)
        //            .opacity(isBeingEdited ? 0.7 : 1)
        .overlay(
            removeCircleButton
        )
    }
}

struct StateHoneyGridCell_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(true) {
            StateHoneyGridCell(isBeingEdited: $0, state: StateQ(nameID: 0, options: []), algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])))
                .frame(width: (UIScreen.main.bounds.width - 50) / 3.2, height: 110)
                .shadow(radius: 5)
                .environmentObject(AlgorithmViewModel())
        }
    }
}

extension StateHoneyGridCell {
    private var removeCircleButton: some View {
        Button {
            withAnimation {
                viewModel.removeState(algorithm: algorithm, state: state)
            }
        } label: {
            Image(systemName: "minus.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.title2)
        }
        .disabled(!isBeingEdited || viewModel.getAlgorithm(algorithm).states.count == 1)
        .offset(x: -43, y: -40)
        .opacity(isBeingEdited ? (viewModel.getAlgorithm(algorithm).states.count != 1 ? 1 : 0.7) : 0)
    }
}
