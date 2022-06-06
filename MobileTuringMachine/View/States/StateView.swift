//
//  StateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.06.2022.
//

import SwiftUI

struct StateView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    let stateID: Int
    
    var body: some View {
        if stateID == viewModel.states.count {
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                    .padding()
                    .frame(width: 98, height: 56)
                    .background(Color.secondaryBackground)
                    .cornerRadius(12)
            }
        } else {
            Text("State \(stateID)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding()
                .background(Color.secondaryBackground)
                .cornerRadius(12)
        }
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView(stateID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
