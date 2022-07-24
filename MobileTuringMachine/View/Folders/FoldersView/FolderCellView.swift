//
//  FolderCellView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.07.2022.
//

import SwiftUI

struct FolderCellView: View {
    @Binding var selection: Folder?
    @Binding var editMode: EditMode
    let folder: Folder
    let level: CGFloat
    
    var body: some View {
        Button {
            withAnimation {
                selection = folder
            }
        } label: {
            if !folder.wrappedSubFolders.isEmpty {
                CustomFolderNavigationLink(editMode: $editMode, selectedFolder: $selection, folder: folder)
                    .padding(.vertical, 9)
                    .padding(.leading, 10)
                    .padding(.leading, level * 20)
            } else {
                CustomFolderNavigationLink(editMode: $editMode, selectedFolder: $selection, folder: folder)
                    .padding(.vertical, 9)
                    .padding(.leading, 10)
                    .padding(.trailing, 29.5)
                    .padding(.leading, level * 20)
                    .background(
                        selection == folder
                        ? Color(UIColor.systemGray2)
                            .opacity(0.7)
                            .cornerRadius(10)
                        : Color.clear.opacity(1).cornerRadius(10)
                    )
            }
        }
    }
}

struct ExpandableCellView: View {
    @State private var isOpened = false
    @Binding var selection: Folder?
    @Binding var editMode: EditMode
    let folder: Folder
    let level: CGFloat
    
    init(selection: Binding<Folder?>, editMode: Binding<EditMode>, folder: Folder, level: CGFloat = 0) {
        self._selection = selection
        self._editMode = editMode
        self.folder = folder
        self.level = level
    }
    
    var body: some View {
        if !folder.wrappedSubFolders.isEmpty {
            CustomDisclosureGroup(isExpended: $isOpened, selectionColor: selection == folder ? Color(UIColor.systemGray2) : .clear) {
                ForEach(folder.wrappedSubFolders, id: \.self) { subFolder in
                    ExpandableCellView(selection: $selection, editMode: $editMode, folder: subFolder, level: level + 1)
                }
            } label: {
                FolderCellView(selection: $selection, editMode: $editMode, folder: folder, level: level)
            }
        } else {
            FolderCellView(selection: $selection, editMode: $editMode, folder: folder, level: level)
        }
    }
}

struct CustomExpandableList: View {
    @Binding var selection: Folder?
    @Binding var editMode: EditMode
    let folders: [Folder]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(folders, id: \.self) { folder in
                ExpandableCellView(selection: $selection, editMode: $editMode, folder: folder)
            }
        }
        .padding(.horizontal)
        .background(
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
        )
    }
}
