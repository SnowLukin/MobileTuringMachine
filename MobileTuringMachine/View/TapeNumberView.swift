//
//  TapeNumberView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.04.2022.
//

import SwiftUI

struct TapeNumberView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    let tapeID: Int
    
    var body: some View {
        HStack {
            Text("Tape")
                .font(.title3)
                .fontWeight(.semibold)
            Text("\(tapeID)")
                .font(.title3)
                .fontWeight(.semibold)
        }.frame(width: 100, height: 40)
            .background(Color.secondaryBackground)
            .cornerRadius(10)
    }
}

struct TapeNumberView_Previews: PreviewProvider {
    static var previews: some View {
        TapeNumberView(tapeID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
