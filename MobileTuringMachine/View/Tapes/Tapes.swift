//
//  Tapes.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct Tapes: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.tapes) { tape in
                TapeSectionOpening(tape: tape)
            }
        }
        .navigationTitle("Tapes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        viewModel.addTape()
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct Tapes_Previews: PreviewProvider {
    static var previews: some View {
        Tapes()
            .environmentObject(TapeContentViewModel())
    }
}
