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
        if UIDevice.current.userInterfaceIdiom == .phone {
            FolderAlgorithmPhoneView()
        } else {
            NavigationView {
                FoldersView()
                AlgorithmsView()
                AlgorithmView()
            }.navigationViewStyle(.columns)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(AlgorithmViewModel())
    }
}
