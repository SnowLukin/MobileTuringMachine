//
//  AllExitsView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.04.2022.
//
//
//import SwiftUI
//
//struct AllExitsView: View {
//    
//    @EnvironmentObject private var viewModel: TapeContentViewModel
//    
//    var body: some View {
//        LazyVGrid(columns: getLayout(viewModel.exits.count,spacing: 1), alignment: .leading) {
//            ForEach(0..<viewModel.exits.count) { exitID in
//                LazyHGrid(rows: getLayout(viewModel.amountOfStates, spacing: 30)) {
//                    ForEach(0..<viewModel.amountOfStates, id: \.self) { stateID in
//                        ExitView(stateID: stateID, exitID: exitID)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct AllExitsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllExitsView()
//            .environmentObject(TapeContentViewModel())
//    }
//}
//
//extension AllExitsView {
//    private func getLayout(_ amountOfObjects: Int, spacing: CGFloat?) -> [GridItem] {
//        var layout: [GridItem] = []
//        for _ in 0..<amountOfObjects {
//            layout.append(GridItem(.fixed(70), spacing: spacing))
//        }
//        return layout
//    }
//}
