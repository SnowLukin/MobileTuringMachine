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
            HStack(alignment: .top) {
                VStack(spacing: 6) {
                    AllTapesNumberView()
                        .frame(width: 80)
                        .padding([.top], 17)
                    StatesView()
                        .frame(width: 50)
                }
                ScrollView(.horizontal) {
                    VStack(alignment: .leading) {
                        CombinationsView()
                            .padding(.leading)
                        AllExitsView()
                            .padding(.top, 7)
                    }.padding([.top, .bottom])
                }
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
