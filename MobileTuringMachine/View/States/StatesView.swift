//
//  StatesView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 05.06.2022.
//

import SwiftUI

struct StatesView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var isBeingEdited = false
    
    var body: some View {
        CustomVerticalGrid(
            columns: 3,
            items: Array(0...viewModel.states.count)) { itemSize, itemIndex in
                StateView(isBeingEdited: $isBeingEdited, stateID: itemIndex)
                    .frame(width: itemSize)
            }
            .padding()
            .toolbar {
                Button {
                    withAnimation {
                        isBeingEdited.toggle()
                    }
                } label: {
                    Text(isBeingEdited ? "Done" : "Edit")
                }
            }
            .navigationTitle("States")
    }
}

struct StatesView_Previews: PreviewProvider {
    static var previews: some View {
        StatesView()
            .environmentObject(TapeContentViewModel())
    }
}
