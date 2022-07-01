//
//  AlgorithmView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI

struct AlgorithmView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var isChanged = false
    @State private var showSettings = false
    @State private var showEditAlgorithmNameAlert = false
    @State private var algorithmNameText = ""
    @State private var showInfo = false
    @State private var showExport = false
    
    let algorithm: Algorithm
    
    var body: some View {
        ZStack {
            VStack {
                ConfigurationsView(showSettings: $showSettings, algorithm: algorithm)
                    .disabled(isChanged)
                if isChanged {
                    Text("Reset to enable configurations")
                        .font(.body)
                        .foregroundColor(.red)
                }
                TapesWorkView(algorithm: algorithm)
                    .shadow(radius: 1)
            }.zIndex(1)
            PlayStack(isChanged: $isChanged, algorithm: algorithm).zIndex(2)
        }
        .navigationTitle("\(algorithm.name)")
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        showExport.toggle()
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        showInfo = true
                    }
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            InfoView(algorithm: algorithm)
        }
        .onAppear {
            algorithmNameText = algorithm.name
        }
        .onChange(of: isChanged) { _ in
            if isChanged {
                withAnimation {
                    showSettings = false
                }
            }
        }
//        .fileExporter(
//            isPresented: $showExport,
//            document: DocumentManager(algorithm: viewModel.getAlgorithm(algorithm)),
//            contentType: .mtm
//        ) { result in
//            switch result {
//            case .success:
//                print("File successfully exported")
//            case .failure:
//                print("Error occupied. Failed exporting the file.")
//            }
//        }
    }
}

struct AlgorithmView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        return AlgorithmView(algorithm: viewModel.dataManager.savedAlgorithms[0])
    }
}
