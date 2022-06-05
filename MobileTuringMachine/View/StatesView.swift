//
//  StatesView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 16.03.2022.
//

import SwiftUI
//
//struct StatesView: View {
//
//    @EnvironmentObject private var viewModel: TapeContentViewModel
//
//    private var layout = [
//        GridItem(.fixed(80))
//    ]
//
//    var body: some View {
//        LazyVGrid(columns: layout) {
//            ForEach(0..<viewModel.amountOfStates, id: \.self) { state in
//                HStack (spacing: 0) {
//                    Text("Q")
//                        .fontWeight(.semibold)
//                    Text("\(state)")
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                }.frame(width: 80, height: 30 + CGFloat(viewModel.tapes.count * 27))
//                    .background(Color.secondaryBackground)
//                    .cornerRadius(9)
//                    .padding(.bottom, 8)
//            }
//
//        }
//    }
//}
//
//struct StatesView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatesView()
//            .environmentObject(TapeContentViewModel())
//    }
//}
