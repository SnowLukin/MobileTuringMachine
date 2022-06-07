//
//  TapeContent.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeContentView: View {

    @EnvironmentObject private var viewModel: TapeContentViewModel
    
//    let tapeContent: TapeContent
    let component: TapeContent
    let tapeID: Int
    
    var body: some View {
        Button {
            viewModel.tapes[tapeID].headIndex = component.id
        } label: {
            Text(component.value)
                .foregroundColor(
                    viewModel.tapes[tapeID].headIndex == component.id
                    ? .white
                    : .secondary
                )
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    viewModel.tapes[tapeID].headIndex == component.id
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
        TapeContentView(component: TapeContent(id: 0, value: "a"), tapeID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
