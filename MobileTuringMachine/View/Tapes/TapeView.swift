//
//  TapeView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var tapeID: Int
    
    var layout: [GridItem] = [
        GridItem(.flexible(minimum: 25))
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                tapeGrid
                    .onAppear {
//                        viewModel.tapes[tapeID].headIndex = 0
                        withAnimation {
                            value.scrollTo(viewModel.tapes[tapeID].headIndex, anchor: .center)
                        }
                    }
                    .onChange(of: viewModel.tapes[tapeID].headIndex) { newValue in
                        withAnimation {
                            value.scrollTo(newValue, anchor: .center)
                        }
                    }
            }
        }
        .frame(height: 40)
        .background(Color.secondaryBackground)
        .cornerRadius(9)
    }
}

struct TapeView_Previews: PreviewProvider {
    static var previews: some View {
        TapeView(tapeID: 0)
            .preferredColorScheme(.dark)
            .padding()
            .environmentObject(TapeContentViewModel())
    }
}


extension TapeView {
    
    private var tapeGrid: some View {
        LazyHGrid(rows: layout) {
            ForEach(viewModel.tapes[tapeID].components) { component in
                TapeContentView(component: component, tapeID: tapeID)
            }
        }
        .padding(.horizontal)
    }
    
    private func getValueForTapeContent(_ id: Int) -> String {
        (0..<viewModel.tapes[tapeID].input.count).contains(id)
        ? viewModel.tapes[tapeID].input.map { String($0) }[id]
        : "_"
    }
}
