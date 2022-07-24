//
//  AlgorithmsView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI

struct AlgorithmsView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    @State private var showInfo = false
    @State private var showEditSheet = false
    @State private var sorting: Sortings = .dateEdited
    @State private var sortingOrder: SortingOrder = .up
    @State private var editMode: EditMode = .inactive
    @State private var showImport = false
    @State private var showExport = false
    @State private var showMoveAlgorithmView = false
    @State private var showMoveSelectedAlgorithmsView = false
    @State private var algorithmForExport: Algorithm?
    @State private var selectedAlgorithm: Algorithm?
    @State private var pinnedExpanded = true
    @State private var unpinnedExpanded = true
    
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
            wrappedAlgorithmsView(folder)
                .navigationTitle(folder.name)
                .onChange(of: viewModel.selectedAlgorithm) { newValue in
                    selectedAlgorithm = newValue
                }
                // getting rid of .transient editMode
                // after deleting all elements in list
                .onChange(of: searchResults) { newValue in
                    if (editMode == .active || editMode == .transient) && newValue.isEmpty {
                        editMode = .inactive
                    }
                }
                .fileImporter(isPresented: $showImport, allowedContentTypes: [.mtm], allowsMultipleSelection: false) { result in
                    do {
                        guard let selectedFileURL: URL = try result.get().first else {
                            print("Failed getting url")
                            return
                        }
                        if selectedFileURL.startAccessingSecurityScopedResource() {
                            guard let data = try? Data(contentsOf: selectedFileURL) else {
                                print("Failed getting data from url: \(selectedFileURL)")
                                return
                            }
                            guard let algorithm = try? JSONDecoder().decode(AlgorithmJSON.self, from: data) else {
                                print("Failed decoding file.")
                                return
                            }
                            defer {
                                selectedFileURL.stopAccessingSecurityScopedResource()
                            }
                            withAnimation {
                                viewModel.importAlgorithm(algorithm, to: folder)
                            }
                            print("Algorithm imported successfully.")
                        } else {
                            print("Error occupied. Failed accessing security scoped resource.")
                        }
                    } catch {
                        print("Error occupied: \(error.localizedDescription)")
                    }
                }
                .sheet(isPresented: $showMoveSelectedAlgorithmsView) {
                    if let chosenFolder = viewModel.selectedFolder {
                        if viewModel.listSelection.isEmpty {
                            MoveFolderView(
                                folder: chosenFolder,
                                algorithms: folder.wrappedAlgorithms, editMode: $editMode
                            )
                        } else {
                            MoveFolderView(
                                folder: chosenFolder,
                                algorithms: Array(viewModel.listSelection), editMode: $editMode
                            )
                        }
                    }
                }
                .environment(\.editMode, $editMode)
        } else {
            Text("No folder selected")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

struct AlgorithmsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        for algorithm in folder.wrappedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm(to: folder)
        return AlgorithmsView()
            .environmentObject(AlgorithmViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

extension AlgorithmsView {
    private func wrappedAlgorithmsView(_ folder: Folder) -> some View {
        ZStack {
            if folder.wrappedAlgorithms.isEmpty {
                Text("No Algorithms")
                    .foregroundColor(.secondary)
                    .font(.title2)
            } else {
                algorithmsList
            }
            AddAlgorithmView(showMoveAlgorithmView: $showMoveSelectedAlgorithmsView, editMode: $editMode, folder: folder)
        }
        .toolbar {
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
                            showEditView: $showEditSheet, sorting: $sorting,
                            sortingOrder: $sortingOrder, editMode: $editMode, showImport: $showImport, folder: folder
                        ).frame(width: UIScreen.main.bounds.width / 2.5, height: 270)
                    }
                    
                }
            }
        }
    }
    
    private var algorithmsList: some View {
        
        let pinnedAlgorithms = searchResults.filter { $0.pinned }
        let unpinnedAlgorithms = searchResults.filter { !$0.pinned }
        let algorithmList = List(selection: $viewModel.listSelection) {
            if !pinnedAlgorithms.isEmpty {
                Section("Pinned") {
                    ForEach(pinnedAlgorithms, id: \.self) { algorithm in
                        CustomAlgorithmButton(editMode: $editMode, algorithm: algorithm)
                            .listRowBackground(
                                viewModel.selectedAlgorithm == algorithm
                                ? Color.blue.opacity(0.5)
                                : colorScheme == .dark
                                ? Color.secondaryBackground
                                : Color.background
                            )
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
                                    withAnimation {
                                        editMode = .transient
                                        viewModel.togglePinAlgorithm(algorithm)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            editMode = .inactive
                                        }
                                    }
                                } label: {
                                    Image(systemName: "pin.fill")
                                }.tint(.orange)
                            }
                    }
                }
            }
            if !unpinnedAlgorithms.isEmpty {
                Section("Algorithms") {
                    ForEach(unpinnedAlgorithms, id: \.self) { algorithm in
                        CustomAlgorithmButton(editMode: $editMode, algorithm: algorithm)
                            .listRowBackground(
                                viewModel.selectedAlgorithm == algorithm
                                ? Color.blue.opacity(0.5)
                                : colorScheme == .dark
                                ? Color.secondaryBackground
                                : Color.background
                            )
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
                                    withAnimation {
                                        editMode = .transient
                                        viewModel.togglePinAlgorithm(algorithm)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            editMode = .inactive
                                        }
                                    }
                                } label: {
                                    Image(systemName: "pin.fill")
                                }.tint(.orange)
                            }
                    }
                }
            }
        }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText)
        return algorithmList
    }
}
