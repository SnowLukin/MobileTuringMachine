//
//  AllExitsView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.04.2022.
//

import SwiftUI

struct AllExitsView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        LazyHGrid(rows: getLayout(viewModel.amountOfStates)) {
            ForEach(0..<viewModel.exits.count) { exitID in
                LazyVGrid(columns: getLayout(viewModel.exits.count)) {
                    ForEach(0..<viewModel.amountOfStates, id: \.self) { stateID in
                        ExitView(stateID: stateID, exitID: exitID)
                    }
                }
            }
        }
    }
}

struct AllExitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllExitsView()
            .environmentObject(TapeContentViewModel())
    }
}

extension AllExitsView {
    private func getLayout(_ amountOfObjects: Int) -> [GridItem] {
        var layout: [GridItem] = []
        for _ in 0..<amountOfObjects {
            layout.append(GridItem(.fixed(70)))
        }
        return layout
    }
}
