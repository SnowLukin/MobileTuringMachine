//
//  AlgorithmEditView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 01.07.2022.
//

import SwiftUI

struct AlgorithmEditView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showEditView: Bool
    @Binding var sorting: Sortings
    @Binding var sortingOrder: SortingOrder
    @Binding var editMode: EditMode
    @Binding var showImport: Bool
    
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
                importButton
                Section {
                    selectButton
                    sortButton
                }
            }
            .onAppear {
                UITableView.appearance().sectionFooterHeight = 0
            }
        }
        .background(
            colorScheme == .dark
            ? Color.background
            : Color.secondaryBackground
        )
    }
}

struct AlgorithmEditView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        return StatefulPreviewWrapper(true) {
            AlgorithmEditView(showEditView: $0, sorting: .constant(.dateEdited), sortingOrder: .constant(.up), editMode: .constant(.inactive), showImport: .constant(false), folder: folder)
        }
    }
}

extension AlgorithmEditView {
    
    private var importButton: some View {
        Button {
            withAnimation {
                showImport.toggle()
                showEditView.toggle()
            }
        } label: {
            HStack {
                Text("Import Algorithm")
                Spacer()
                Image(systemName: "square.and.arrow.down")
            }
        }.foregroundColor(.primary)
    }
    
    private var selectButton: some View {
        Button(role: .cancel) {
            withAnimation {
                editMode = .active
                showEditView = false
            }
        } label: {
            HStack {
                Text("Select Algorithms")
                Spacer()
                Image(systemName: "checkmark.circle")
            }.foregroundColor(.primary)
        }
    }
    
    private var sortButton: some View {
        Menu {
            Section {
                Button {
                    withAnimation {
                        sortingOrder = .down
                        showEditView.toggle()
                    }
                } label: {
                    HStack {
                        if sortingOrder == .down {
                            Image(systemName: "checkmark")
                        }
                        Text(sorting == .name ? "Z to A" : "Oldest to Newest")
                    }
                }
                Button {
                    withAnimation {
                        sortingOrder = .up
                        showEditView.toggle()
                    }
                } label: {
                    HStack {
                        if sortingOrder == .up {
                            Image(systemName: "checkmark")
                        }
                        Text(sorting == .name ? "A to Z" : "Newest to Oldest")
                    }
                }
            }
            
            Button {
                withAnimation {
                    sorting = .name
                    showEditView.toggle()
                }
            } label: {
                HStack {
                    if sorting == .name {
                        Image(systemName: "checkmark")
                    }
                    Text("Name")
                }
            }
            
            Button {
                withAnimation {
                    sorting = .dateCreated
                    showEditView.toggle()
                }
            } label: {
                HStack {
                    if sorting == .dateCreated {
                        Image(systemName: "checkmark")
                    }
                    Text("Date Created")
                }
            }
            Button {
                withAnimation {
                    sorting = .dateEdited
                    showEditView.toggle()
                }
            } label: {
                HStack {
                    if sorting == .dateEdited {
                        Image(systemName: "checkmark")
                    }
                    Text("Date Edited")
                }
            }

        } label: {
            HStack {
                Text("Sort Algorithms By \(sorting.rawValue)")
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(.primary)
            }
        }
    }
    
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
                showEditView.toggle()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.footnote.bold())
                .foregroundColor(
                    colorScheme == .dark
                    ? Color.init(uiColor: UIColor.lightGray)
                    : Color.init(uiColor: UIColor.darkGray)
                )
                .padding(6)
                .background(
                    colorScheme == .dark
                    ? Color.secondaryBackground
                    : Color.init(uiColor: UIColor.systemGray5)
                )
                .clipShape(Circle())
                .offset(y: -15)
        }
    }
}
