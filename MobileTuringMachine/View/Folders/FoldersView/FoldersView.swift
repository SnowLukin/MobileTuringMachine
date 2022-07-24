//
//  FoldersView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.07.2022.
//

import SwiftUI
import UIKit

struct FoldersView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var editMode: EditMode = .inactive
    @State private var showNameTakenAlert: Bool = false
    @State private var selectedFolder: Folder?
    
    var body: some View {
        ZStack {
            folderPadList
            addFolderButton
        }
        .navigationTitle("Folders")
        .onAppear {
            selectedFolder = viewModel.selectedFolder
        }
        .onChange(of: viewModel.selectedFolder) { newValue in
            selectedFolder = newValue
        }
        .environment(\.editMode, $editMode)
        // Edit folders
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if editMode != .active {
                        withAnimation {
                            editMode = .active
                        }
                    } else {
                        withAnimation {
                            editMode = .inactive
                        }
                    }
                } label: {
                    Text(editMode != .active ? "Edit" : "Done")
                }
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
    }
}

extension FoldersView {
    
    private var folderPadList: some View {
        
        CustomExpandableList(selection: $selectedFolder, editMode: $editMode, folders: viewModel.dataManager.savedFolders.filter { $0.parentFolder == nil })
        
//        List(viewModel.dataManager.savedFolders.filter { $0.parentFolder == nil }, children: \.optionalSubFolders) { folder in
//            CustomFolderNavigationLink(editMode: $editMode, selectedFolder: $selectedFolder, folder: folder)
//                .listRowBackground(
//                    viewModel.selectedFolder == folder
//                    ? Color.blue.opacity(0.5)
//                    : colorScheme == .dark
//                        ? Color.secondaryBackground
//                        : Color.background
//                )
//        }
//        .listStyle(.insetGrouped)
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
                    } secondaryAction: {}
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
}
