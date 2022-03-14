//
//  TapeContent.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeContentView: View {

    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let tapeContent: TapeContent
    
    var body: some View {
        Button {
            viewModel.changeCurrentIndex(to: tapeContent.id)
        } label: {
            Text(tapeContent.value)
                .foregroundColor(viewModel.isTapeContentSelected(tapeContent) ? .white : .secondary)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 25, height: 35)
                .background(viewModel.isTapeContentSelected(tapeContent) ? .blue : Color.secondaryBackground)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.secondary, lineWidth: 1)
                )
        }
    }
}

struct TapeContentView_Previews: PreviewProvider {
    static var previews: some View {
        TapeContentView(tapeContent: TapeContent(id: 1))
            .environmentObject(TapeContentViewModel())
    }
}
