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
            if let tapeIndex = viewModel.tapes.firstIndex(where: { $0.id == tape.id }) {
                viewModel.tapes[tapeIndex].headIndex = component.id
            }
        } label: {
            Text(component.value)
                .foregroundColor(
                    tape.headIndex == component.id
                    ? .white
                    : .secondary
                )
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    tape.headIndex == component.id
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
