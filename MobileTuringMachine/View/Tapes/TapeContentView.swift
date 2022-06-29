//
//  TapeContent.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeContentView: View {

    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    let component: TapeComponent
    
    var body: some View {
        Button {
            viewModel.changeHeadIndex(to: component)
        } label: {
            Text(component.value)
                .foregroundColor(
                    component.tape.headIndex == component.id
                    ? .white
                    : .secondary
                )
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    component.tape.headIndex == component.id
                    ? .blue
                    : .secondaryBackground
                )
                .cornerRadius(35 / 2)
                .overlay(
                    Circle()
                        .stroke(.secondary)
                )
        }
    }
}

struct TapeContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let algorithm = DataManager.shared.savedAlgorithms[0]
        
        TapeContentView(component: algorithm.wrappedTapes[0].wrappedComponents[0])
            .environmentObject(AlgorithmViewModel())
    }
    
}
