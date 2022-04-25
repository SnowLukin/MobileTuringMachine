//
//  CombinationsView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 16.03.2022.
//

import SwiftUI

struct CombinationsView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        LazyVGrid(columns: getLayout()) {
            ForEach(viewModel.getArrayOfAllExits(), id: \.self) { combination in
                VStack {
                    ForEach(combination.map { String($0) }, id: \.self) { letter in
                        Text(letter)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(height: 30)
                    }.frame(width: CGFloat(35 * viewModel.tapes.count))
                }
            }
        }
    }
}

struct CombinationsView_Previews: PreviewProvider {
    static var previews: some View {
        CombinationsView()
            .environmentObject(TapeContentViewModel())
    }
}

extension CombinationsView {
    
    private func getLayout() -> [GridItem] {
        var layout: [GridItem] = []
        for _ in 0..<viewModel.getArrayOfAllExits().count {
            layout.append( GridItem(.fixed(70)) )
        }
        return layout
    }
    
}
