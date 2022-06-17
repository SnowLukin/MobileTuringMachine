//
//  TapeContent.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeContentView: View {

    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let component: TapeContent
    let tape: Tape
    
    var body: some View {
        Button {
            viewModel.changeHeadIndex(of: tape, to: component)
        } label: {
            Text(viewModel.getTapeComponent(tape: tape, component: component).value)
                .foregroundColor(
                    viewModel.getTape(tape: tape).headIndex == viewModel.getTapeComponent(tape: tape, component: component).id
                    ? .white
                    : .secondary
                )
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    viewModel.getTape(tape: tape).headIndex == viewModel.getTapeComponent(tape: tape, component: component).id
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
        TapeContentView(component: TapeContent(id: 0, value: "a"), tape: Tape(nameID: 0, components: [TapeContent(id: 0)]))
            .environmentObject(TapeContentViewModel())
    }
}
