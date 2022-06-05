//
//  ExitView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.04.2022.
//

import SwiftUI
//
//struct ExitView: View {
//    
//    @EnvironmentObject private var viewModel: TapeContentViewModel
//    
//    let stateID: Int
//    let exitID: Int
//    
//    var body: some View {
//        
//        Menu {
//            Button("Something") {}
//            Button("Something") {}
//            Menu("Hello") {
//                Text("Chuppi")
//            }
//        } label: {
//            VStack(spacing: 5) {
//                ForEach(0..<viewModel.exits[exitID].toLetters[stateID].count) { letterID in
//                    HStack(spacing: 0) {
//                        Text(getText(letterID: letterID))
//                            .frame(width: 20, height: 20)
//                        Image(systemName: getImage())
//                            .frame(width: 20, height: 20)
//                    }.font(.subheadline.bold())
//                }
//                Divider()
//                HStack(spacing: 0) {
//                    Text("Q").fontWeight(.semibold)
//                    Text("\(stateID)")
//                        .font(.caption)
//                        .fontWeight(.bold)
//                }
//            }
//            .frame(width: 50)
//            .padding(5)
//            .background(Color.secondaryBackground)
//            .cornerRadius(10)
//        }
//    }
//}
//
//struct ExitView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExitView(stateID: 0, exitID: 0)
//            .environmentObject(TapeContentViewModel())
//    }
//}
//
//extension ExitView {
//    
//    private func getText(letterID: Int) -> String {
//        let word = viewModel.exits[exitID].toLetters[stateID]
//        let index = word.index(word.startIndex, offsetBy: letterID)
//        return String(word[index])
//    }
//    
//    private func getImage() -> String {
//        switch viewModel.exits[exitID].moving[stateID] {
//        case .stay:
//            return "arrow.counterclockwise"
//        case .left:
//            return "arrow.left"
//        case .right:
//            return "arrow.right"
//        }
//    }
//}
