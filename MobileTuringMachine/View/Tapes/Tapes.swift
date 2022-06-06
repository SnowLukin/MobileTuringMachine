//
//  Tapes.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct Tapes: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        CustomVerticalGrid(columns: 1, items: Array(0..<viewModel.tapes.count)) { itemSize, tapeIndex in
            TapeSectionOpening(tapeID: tapeIndex)
        }
    }
}

struct Tapes_Previews: PreviewProvider {
    static var previews: some View {
        Tapes()
            .environmentObject(TapeContentViewModel())
    }
}
