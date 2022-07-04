//
//  ContentView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    var body: some View {
        FoldersView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(AlgorithmViewModel())
    }
}
