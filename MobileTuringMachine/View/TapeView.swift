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
    
    private var layout: [GridItem] = [
        GridItem(.flexible(minimum: 25))
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                tapeGrid
                    .onAppear {
                        viewModel.currentIndex = 0
                        value.scrollTo(0, anchor: .center)
                    }
                    .onChange(of: viewModel.currentIndex) { newValue in
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
    
    init(tapeID: Int) {
        self.tapeID = tapeID
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
            ForEach(-216..<217, id: \.self) { contentID in
                TapeContentView(tapeContent: TapeContent(id: contentID, value: getValueForTapeContent(contentID)))
            }
        }
        .padding(.horizontal)
    }
    
    private func getCharOnIndex(_ id: Int) -> String {
        let index = viewModel.tapes[tapeID].input.index(
            viewModel.tapes[tapeID].input.startIndex, offsetBy: id
        )
        return String(viewModel.tapes[tapeID].input[index])
    }
    
    private func getValueForTapeContent(_ id: Int) -> String {
        guard tapeID <= viewModel.tapes.count - 1 else { return "_" }
        return (0..<viewModel.tapes[tapeID].input.count).contains(id)
        ? getCharOnIndex(id)
        : "_"
    }
    
}
