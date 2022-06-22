//
//  ListOfAlgorithms.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI

struct ListOfAlgorithms: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.algorithms) { algorithm in
                NavigationLink {
                    AlgorithmView(algorithm: algorithm)
                } label: {
                    Text(algorithm.name)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ListOfAlgorithms_Previews: PreviewProvider {
    static var previews: some View {
        ListOfAlgorithms()
            .environmentObject(AlgorithmViewModel())
    }
}
