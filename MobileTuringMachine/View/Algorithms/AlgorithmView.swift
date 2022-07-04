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
    
    var body: some View {
        if let algorithm = viewModel.selectedAlgorithm {
            wrappedAlgorithmView(algorithm)
                .navigationTitle("\(algorithm.name)")
        } else {
            initualView(viewModel.selectedFolder)
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
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        for algorithm in folder.wrappedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm(to: folder)
        return AlgorithmView()
    }
}

extension AlgorithmView {
    
    private func initualView(_ folder: Folder?) -> some View {
        VStack {
            Text("No algorithm selected")
                .font(.title2)
                .foregroundColor(.secondary)
            HStack {
                Text("Create a new algorithm: ")
                    .foregroundColor(.secondary)
                    .font(.title3)
                Button {
                    if let folder = folder {
                        withAnimation {
                            viewModel.addAlgorithm(to: folder)
                        }
                    }
                } label: {
                    Image(systemName: "doc.badge.plus")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
        }
        // Toolbar for empty algorithm view
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let folder = folder {
                    Button {
                        withAnimation {
                            viewModel.addAlgorithm(to: folder)
                        }
                    } label: {
                        Image(systemName: "doc.badge.plus")
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    private func wrappedAlgorithmView(_ algorithm: Algorithm) -> some View {
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
            }
            PlayStack(isChanged: $isChanged, algorithm: algorithm)
        }
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
    }
}
