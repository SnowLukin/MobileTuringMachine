//
//  AlgorithmsPhoneView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 09.07.2022.
//

import SwiftUI

struct AlgorithmsPhoneView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    @State private var showInfo = false
    @State private var showEditSheet = false
//    @State private var openFile = false
    @State private var sorting: Sortings = .dateEdited
    @State private var sortingOrder: SortingOrder = .up
    @State private var editMode: EditMode = .inactive
    @State private var selectedAlgorithm: Algorithm?
    
    @Binding var showFolders: Bool
    
    var searchResults: [Algorithm] {
        if let folder = viewModel.selectedFolder {
            return viewModel.getSearchResult(searchText, sorting: sorting, sortingOrder: sortingOrder, folder: folder)
        } else {
            print("Couldnt find folder")
            return []
        }
    }
    
    var body: some View {
        if let folder = viewModel.selectedFolder {
            NavigationView {
                wrappedAlgorithmsView(folder)
                    .navigationTitle(folder.name)
                    .onAppear {
                        // Trying to make it as close as possible to deselection of navlink on iphones
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.selectedAlgorithm = nil
                        }
                    }
                    .onChange(of: viewModel.selectedAlgorithm) { newValue in
                        print("viewModel.selectedAlgorithm changed")
                        selectedAlgorithm = newValue
                    }
                    .onChange(of: searchResults) { newValue in
                        // getting rid of .transient editMode
                        // after deleting all elements in list
                        if (editMode == .active || editMode == .transient) && newValue.isEmpty {
                            editMode = .inactive
                        }
                    }
                    .environment(\.editMode, $editMode)
            }.navigationViewStyle(.stack)
        } else {
            Text("No folder selected")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

struct AlgorithmsPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        for algorithm in folder.wrappedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm(to: folder)
        return AlgorithmsPhoneView(showFolders: .constant(false))
            .environmentObject(AlgorithmViewModel())
    }
}

extension AlgorithmsPhoneView {
    private func wrappedAlgorithmsView(_ folder: Folder) -> some View {
        ZStack {
            if folder.wrappedAlgorithms.isEmpty {
                Text("No Algorithms")
                    .foregroundColor(.secondary)
                    .font(.title2)
            } else {
                algorithmsList
            }
            AddAlgorithmView(editMode: $editMode, folder: folder)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation {
                        showFolders.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.selectedFolder = nil
                        }
                    }
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "chevron.left")
                            .font(Font.headline)
                        Image(systemName: "folder")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if editMode == .active || editMode == .transient {
                    Button {
                        withAnimation {
                            editMode = .inactive
                            viewModel.listSelection = []
                        }
                    } label: {
                        Text("Done")
                    }
                } else {
                    Button {
                        withAnimation {
                            showEditSheet.toggle()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .popover(isPresented: $showEditSheet) {
                        AlgorithmEditView(
                            showEditView: $showEditSheet,
                            sorting: $sorting,
                            sortingOrder: $sortingOrder,
                            editMode: $editMode,
                            folder: folder
                        )
                    }
                }
            }
        }
    }
    
    private var algorithmsList: some View {
        List(searchResults, id: \.self, selection: $viewModel.listSelection) { algorithm in
            customNavigationLink(algorithm: algorithm)
            .listRowBackground(
                viewModel.selectedAlgorithm == algorithm
                ? Color.blue.opacity(0.5)
                : colorScheme == .dark
                    ? Color.secondaryBackground
                    : Color.background
            )
            .contextMenu {
                if editMode == .inactive {
                    // Pin
                    Button {
                        
                    } label: {
                        Label("Pin Algorithm", systemImage: "pin")
                    }
                    // Send a copy
                    Button {
                        
                    } label: {
                        Label("Send a copy", systemImage: "square.and.arrow.up")
                    }
                    // Move
                    Button {
                        
                    } label: {
                        Label("Move", systemImage: "folder")
                    }
                    // Delete
                    Button(role: .destructive) {
                        withAnimation {
                            if algorithm == viewModel.selectedAlgorithm {
                                viewModel.selectedAlgorithm = nil
                            }
                            viewModel.deleteAlgorithm(algorithm)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) {
                    withAnimation {
                        if algorithm == viewModel.selectedAlgorithm {
                            viewModel.selectedAlgorithm = nil
                        }
                        viewModel.deleteAlgorithm(algorithm)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                }
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button(role: .cancel) {
                    
                } label: {
                    Image(systemName: "pin.fill")
                }.tint(.orange)
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText)
    }
    
    private func customCell(_ algorithm: Algorithm) -> some View {
        VStack(alignment: .leading) {
            Text(algorithm.name)
                .font(.headline)
                .foregroundColor(.primary)
            Text(viewModel.getAlgorithmEditedTimeForTextView(algorithm))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func customNavigationLink(algorithm: Algorithm) -> some View {
        ZStack {
            Button {
                viewModel.selectedAlgorithm = algorithm
            } label: {
                HStack {
                    customCell(algorithm)
                    Spacer()
                }
            }
            NavigationLink(tag: algorithm, selection: $selectedAlgorithm) {
                AlgorithmView()
            } label: {
                EmptyView()
            }.hidden()
        }
    }
}
