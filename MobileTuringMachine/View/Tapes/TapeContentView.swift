//
//  TapeContent.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeContentView: View {

    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let component: TapeContent
    let tape: Tape
    let algorithm: Algorithm
    
    var body: some View {
        Button {
            viewModel.changeHeadIndex(of: tape, to: component, algorithm: algorithm)
        } label: {
            Text(viewModel.getTapeComponent(algorithm: algorithm, tape: tape, component: component).value)
                .foregroundColor(
                    viewModel.getTape(tape: tape, of: algorithm).headIndex == viewModel.getTapeComponent(algorithm: algorithm, tape: tape, component: component).id
                    ? .white
                    : .secondary
                )
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    viewModel.getTape(tape: tape, of: algorithm).headIndex == viewModel.getTapeComponent(algorithm: algorithm, tape: tape, component: component).id
                    ? .blue
                    : .secondaryBackground
                )
                .cornerRadius(35 / 2)
                .overlay(
                    Circle()
                        .stroke(.secondary)
                )
        }
    }
}

struct TapeContentView_Previews: PreviewProvider {
    static var previews: some View {
        TapeContentView(component: TapeContent(id: 0, value: "a"), tape: Tape(nameID: 0, components: [TapeContent(id: 0)]), algorithm: Algorithm(name: "New Algorithm", tapes: [], states: [], stateForReset: StateQ(nameID: 0, options: [])))
            .environmentObject(AlgorithmViewModel())
    }
}
