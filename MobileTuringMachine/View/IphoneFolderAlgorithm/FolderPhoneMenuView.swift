//
//  FolderPhoneMenuView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 09.07.2022.
//

import SwiftUI

struct FolderPhoneView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var editMode: EditMode = .inactive
    @State private var showNameTakenAlert: Bool = false
    @State private var selectedFolder: Folder?
    @Binding var showMenu: Bool
    let sideBarWidth: CGFloat
    
    var body: some View {
        NavigationView {
            ZStack {
                folderPhoneList
                addFolderButton
            }
            .navigationTitle("Folders")
            .onChange(of: viewModel.selectedFolder) { newValue in
                selectedFolder = newValue
            }
        }
        .frame(width: sideBarWidth)
        .frame(maxHeight: .infinity)
        .background(
            Color.secondaryBackground
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .environment(\.editMode, $editMode)
        .navigationViewStyle(.stack)
    }
}

struct FolderPhoneMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for folder in viewModel.dataManager.savedFolders {
            viewModel.deleteFolder(folder)
        }
        viewModel.addFolder(name: "Algorithms")
        viewModel.addFolder(name: "Second")
        viewModel.addFolder(name: "Third")
        return FolderPhoneView(showMenu: .constant(true), sideBarWidth: UIScreen.main.bounds.width)
            .environmentObject(AlgorithmViewModel())
    }
}

extension FolderPhoneView {
    private var folderPhoneList: some View {
        List(viewModel.dataManager.savedFolders) { folder in
            CustomFolderNavigationLinkPhone(showMenu: $showMenu, editMode: $editMode, folder: folder)
                .listRowBackground(
                    viewModel.selectedFolder == folder
                    ? Color.blue.opacity(0.5)
                    : colorScheme == .dark
                        ? Color.secondaryBackground
                        : Color.background
                )
        }
    }
    private var addFolderButton: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    alertWithTextField(
                        title: "New Folder", message: "Enter a name for this folder",
                        hintText: "Name", primaryTitle: "Save", secondaryTitle: "Cancel"
                    ) { newFolderName in
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
