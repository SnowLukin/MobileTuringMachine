//
//  FoldersView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.07.2022.
//

import SwiftUI

struct FoldersView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    private var defaultFolder: Folder? {
        let savedFolders = viewModel.dataManager.savedFolders
        return savedFolders.first
    }
    
    private var defaultAlgorithm: Algorithm? {
        return defaultFolder?.wrappedAlgorithms.first
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.dataManager.savedFolders) { folder in
                NavigationLink {
                    ListOfAlgorithms(folder: folder)
                        .navigationTitle(folder.name)
                } label: {
                    Label {
                        Text(folder.name)
                    } icon: {
                        Image(systemName: "folder")
                            .foregroundColor(.orange)
                    }
                }
            }
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Edit")
                    }
                }
            }
            .navigationTitle("Folders")
            if let defaultFolder = defaultFolder {
                ListOfAlgorithms(folder: defaultFolder)
                    .navigationTitle(defaultFolder.name)
            } else {
                EmptyView()
            }
            
            if let defaultAlgorithm = defaultAlgorithm {
                AlgorithmView(algorithm: defaultAlgorithm)
                    .navigationTitle(defaultAlgorithm.name)
            } else {
                EmptyView()
            }
        }
    }
}

struct FoldersView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for folder in viewModel.dataManager.savedFolders {
            viewModel.deleteFolder(folder)
        }
        viewModel.addFolder(name: "Algorithms")
        viewModel.addFolder(name: "Second")
        viewModel.addFolder(name: "Third")
        return FoldersView()
            .environmentObject(AlgorithmViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
