//
//  FoldersView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.07.2022.
//

import SwiftUI

struct FoldersView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var selectedFolder: Folder? = nil
    @State private var showNameTakenAlert: Bool = false
    
    private var defaultFolder: Folder? {
        let savedFolders = viewModel.dataManager.savedFolders
        return savedFolders.first
    }
    private var defaultAlgorithm: Algorithm? {
        let savedFolders = viewModel.dataManager.savedFolders
//        print(defaultFolder?.wrappedAlgorithms.first?.name ?? "Nil")
        let folder = savedFolders.first
        return folder?.wrappedAlgorithms.first
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                folderList
                addFolderButton
            }
            // Edit folders
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Edit")
                    }
                }
            }
            .navigationTitle("Folders")
            // MARK: default folder section view
            if let defaultFolder = defaultFolder {
                AlgorithmsView(folder: defaultFolder)
                    .navigationTitle(defaultFolder.name)
                    .onAppear {
                        selectedFolder = defaultFolder
                    }
            } else {
                Text("No folder selected")
            }
            // MARK: default algorithm section view
            if let defaultAlgorithm = defaultAlgorithm {
                AlgorithmView(algorithm: defaultAlgorithm)
                    .navigationTitle(defaultAlgorithm.name)
            } else {
                emptyDefaultAlgorithm
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
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}

extension FoldersView {
    private var folderList: some View {
        List(viewModel.dataManager.savedFolders) { folder in
            NavigationLink(tag: folder, selection: $selectedFolder) {
                AlgorithmsView(folder: folder)
                    .navigationTitle(folder.name)
            } label: {
                Label {
                    Text(folder.name)
                } icon: {
                    Image(systemName: "folder")
                        .foregroundColor(.orange)
                }
            }
        }.listStyle(.sidebar)
    }
    
    private var addFolderButton: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    alertWithTextField(title: "New Folder", message: "Enter a name for this folder", hintText: "Name", primaryTitle: "Save", secondaryTitle: "Cancel") { newFolderName in
                        
                        withAnimation {
                            showNameTakenAlert = viewModel.handleAddingNewFolder(name: newFolderName)
                        }
                    } secondaryAction: {
                        // Nothing
                    }
                } label: {
                    Image(systemName: "folder.badge.plus")
                        .font(.title2)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom)
        .alert("Name Taken", isPresented: $showNameTakenAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please choose a different name.")
        }
    }
    
    private var emptyDefaultAlgorithm: some View {
        VStack {
            Text("No algorithm selected")
                .font(.title2)
                .foregroundColor(.secondary)
            HStack {
                Text("Create a new algorithm: ")
                    .foregroundColor(.secondary)
                    .font(.title3)
                Button {
                    if let defaultFolder = defaultFolder {
                        withAnimation {
                            viewModel.addAlgorithm(to: defaultFolder)
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
                if let defaultFolder = defaultFolder {
                    Button {
                        withAnimation {
                            viewModel.addAlgorithm(to: defaultFolder)
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
}
