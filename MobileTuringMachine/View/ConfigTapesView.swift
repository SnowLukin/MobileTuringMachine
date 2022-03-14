//
//  ConfigTapesView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct ConfigTapesView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let tapeID: Int
    
    var body: some View {
        VStack {
            VStack {
                InputView(tapeID: tapeID, purpose: .alphabet)
                InputView(tapeID: tapeID, purpose: .input)
            }
            .padding()
            .background(Color.background)
            .cornerRadius(20)
        }
        
    }
}

struct ConfigTapesView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigTapesView(tapeID: 0)
            .preferredColorScheme(.dark)
            .environmentObject(TapeContentViewModel())
    }
}
