//
//  TapeSectionOpening.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct TapeSectionOpening: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var isOpened = false
    
    let tape: Tape
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Tape \(tape.nameID)")
                        .font(.system(size: 35).bold())
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        withAnimation {
                            isOpened.toggle()
                        }
                    } label: {
                        Text(isOpened ? "Hide" : "Show")
                    }
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding([.top, .bottom], 9)
                .padding([.leading, .trailing], 30)
                
                if isOpened {
                    TapeViewConfigTapesView(tape: tape)
                        .shadow(radius: 5)
                        .padding(.bottom)
                }
            }
        }
        .background(Color.secondaryBackground)
        .cornerRadius(12)
        .padding([.leading, .trailing])
    }
}

struct TapeSectionOpening_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        let algorithm = DataManager.shared.savedAlgorithms[0]
        return TapeSectionOpening(tape: algorithm.wrappedTapes[0])
            .environmentObject(AlgorithmViewModel())
    }
}
