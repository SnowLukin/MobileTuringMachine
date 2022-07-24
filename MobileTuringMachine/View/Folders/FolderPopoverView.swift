//
//  FolderPopoverView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 12.07.2022.
//

import SwiftUI

struct FolderPopoverView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) private var colorScheme
//    @Environment(\.presentationMode) private var presentationMode
    @Binding var editMode: EditMode
    @State private var showErrorRenamingFolderAlert: Bool = false
    @State private var showMoveFolderSheet = false
    @Binding var showCurrentPopover: Bool
    
    let folder: Folder
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                folderTitle
                Spacer()
                dismissButton
            }
            .padding(.top)
            .padding(.horizontal)
            Form {
                addFolderButton
                moveFolderButton
                renameFolderButton
                deleteFolderButton
            }
            .onAppear {
                UITableView.appearance().sectionFooterHeight = 0
            }
        }.background(
            colorScheme == .dark
            ? Color.background
            : Color.secondaryBackground
        )
        .onChange(of: showMoveFolderSheet) { newValue in
            if !showMoveFolderSheet {
                withAnimation {
                    showCurrentPopover = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        editMode = .inactive
                    }
                }
            }
        }
        .alert("Name is already taken", isPresented: $showErrorRenamingFolderAlert, actions: {})
        .sheet(isPresented: $showMoveFolderSheet) {
            MoveFolderView(folder: folder, editMode: $editMode)
        }
    }
}

struct FolderPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for folder in viewModel.dataManager.savedFolders {
            viewModel.deleteFolder(folder)
        }
        viewModel.addFolder(name: "Algorithms")
        return FolderPopoverView(editMode: .constant(.active), showCurrentPopover: .constant(true), folder: viewModel.dataManager.savedFolders[0])
            .environmentObject(AlgorithmViewModel())
    }
}

extension FolderPopoverView {
    private var folderTitle: some View {
        HStack {
            Image(systemName: "folder.fill")
                .symbolRenderingMode(.multicolor)
                .font(.largeTitle)
            Text(folder.name)
                .fontWeight(.semibold)
        }
    }
    
    private var dismissButton: some View {
        Button {
            withAnimation {
                showCurrentPopover = false
                editMode = .inactive
            }
        } label: {
            Image(systemName: "xmark")
                .font(.footnote.bold())
                .foregroundColor(
                    colorScheme == .dark
                    ? Color.init(uiColor: UIColor.lightGray)
                    : Color.init(uiColor: UIColor.darkGray)
                )
                .padding(8)
                .background(
                    colorScheme == .dark
                    ? Color.secondaryBackground
                    : Color.init(uiColor: UIColor.systemGray5)
                )
                .clipShape(Circle())
                .offset(y: -10)
        }
    }
    
    private var addFolderButton: some View {
        Button {
            withAnimation {
//                presentationMode.wrappedValue.dismiss()
                showCurrentPopover = false
                editMode = .inactive
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alertWithTextField(title: "New Folder", message: "Enter a name for this folder", hintText: "Name", primaryTitle: "Save", secondaryTitle: "Cancel") { newFolderName in
                    
                    withAnimation {
                        showErrorRenamingFolderAlert = viewModel.handleAddingNewFolder(name: newFolderName, parentFolder: folder)
                    }
                } secondaryAction: {}
            }
        } label: {
            HStack {
                Text("Add New Folder")
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "folder.badge.plus")
                    .font(.title2.weight(.light))
                    .foregroundColor(.primary)
            }
        }
    }
    private var moveFolderButton: some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showMoveFolderSheet.toggle()
            }
        } label: {
            HStack {
                Text("Move This Folder")
                Spacer()
                Image(systemName: "folder")
                    .font(.title2.weight(.light))
            }.foregroundColor(.primary)
        }
    }
    private var renameFolderButton: some View {
        Button {
            withAnimation {
//                presentationMode.wrappedValue.dismiss()
                showCurrentPopover = false
                editMode = .inactive
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alertWithTextField(title: "Rename Folder", message: nil, hintText: "Name", primaryTitle: "Save", secondaryTitle: "Cancel") { alertText in
                    if viewModel.handleRenamingFolder(folder, newName: alertText) {
                        withAnimation {
                            showErrorRenamingFolderAlert = true
                        }
                    }
                } secondaryAction: {}
            }
        } label: {
            HStack {
                Text("Rename")
                Spacer()
                Image(systemName: "pencil")
                    .font(.title2.weight(.light))
            }.foregroundColor(.primary)
        }
    }
    private var deleteFolderButton: some View {
        Button {
            withAnimation {
                viewModel.deleteFolder(folder)
                editMode = .inactive
            }
        } label: {
            HStack {
                Text("Delete")
                Spacer()
                Image(systemName: "trash")
                    .font(.title2.weight(.light))
            }.foregroundColor(.primary)
        }
    }
}
