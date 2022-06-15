//
//  ConfigTapesView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct ConfigTapesView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let tape: Tape
    
    var body: some View {
        VStack {
            VStack {
                InputView(tape: tape, purpose: .alphabet)
                InputView(tape: tape, purpose: .input)
            }
            .padding()
            .background(Color.background)
            .cornerRadius(20)
        }
    }
}

struct ConfigTapesView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigTapesView(tape: Tape(nameID: 0, components: [TapeContent(id: 0)]))
            .preferredColorScheme(.dark)
            .environmentObject(TapeContentViewModel())
    }
}
