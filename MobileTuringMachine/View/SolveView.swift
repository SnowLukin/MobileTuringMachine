//
//  SolveView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 19.03.2022.
//

import SwiftUI

struct SolveView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                StatesView()
                    .frame(width: 50)
                    .padding(.top, CGFloat(viewModel.tapes.count * (30 + 8)))
                
//                ScrollView(.horizontal) {
//                    VStack(alignment: .trailing) {
//                        CombinationsView()
//                        OptionStatesView()
//                    }.padding([.top, .bottom])
//                }
            }.padding(.horizontal)
        }
    }
    
}

struct SolveView_Previews: PreviewProvider {
    static var previews: some View {
        SolveView()
            .environmentObject(TapeContentViewModel())
    }
}
