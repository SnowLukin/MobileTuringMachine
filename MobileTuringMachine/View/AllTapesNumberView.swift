//
//  AllTapesNumberView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.04.2022.
//

import SwiftUI

struct AllTapesNumberView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        HStack {
            ForEach(viewModel.tapes) { tape in
                TapeNumberView(tapeID: tape.id)
            }.frame(width: 100)
        }
    }
}

struct AllTapesNumberView_Previews: PreviewProvider {
    static var previews: some View {
        AllTapesNumberView()
            .environmentObject(TapeContentViewModel())
    }
}
