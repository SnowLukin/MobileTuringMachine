//
//  MobileTuringMachineApp.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

@main
struct MobileTuringMachineApp: App {
    
    @StateObject private var viewModel = AlgorithmViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
