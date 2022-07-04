//
//  AlgorithmsView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI

struct AlgorithmsView: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var searchText = ""
    @State private var showInfo = false
    @State private var showEditSheet = false
//    @State private var openFile = false
    @State private var sorting: Sortings = .dateEdited
    @State private var sortingOrder: SortingOrder = .up
    @State private var selectedAlgorithm: Algorithm?
    @State private var listSelection: Algorithm?
    @Environment(\.editMode) private var editMode
    
    private var defaultAlgorithm: Algorithm? {
        let savedFolders = viewModel.dataManager.savedFolders
        let folder = savedFolders.first
        return folder?.wrappedAlgorithms.first
    }
    
    var searchResults: [Algorithm] {
        if let folder = viewModel.selectedFolder {
            return viewModel.getSearchResult(searchText, sorting: sorting, sortingOrder: sortingOrder, folder: folder)
        } else {
            return []
        }
    }
    
    var body: some View {
        if let folder = viewModel.selectedFolder {
            wrappedAlgorithmsView(folder)
                .navigationTitle(folder.name)
                // getting rid of .transient editMode
                // after deleting all elements in list
                .onChange(of: searchResults) { newValue in
                    if (editMode?.wrappedValue == .active || editMode?.wrappedValue == .transient) && newValue.isEmpty {
                        editMode?.wrappedValue = .inactive
                    }
                }
        } else {
            Text("No folder selected")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        
        //        .fileImporter(isPresented: $openFile, allowedContentTypes: [.mtm], allowsMultipleSelection: false) { result in
        //            do {
        //                guard let selectedFileURL: URL = try result.get().first else {
        //                    print("Failed getting url.")
        //                    return
        //                }
        //
        //                if selectedFileURL.startAccessingSecurityScopedResource() {
        //                    guard let data = try? Data(contentsOf: selectedFileURL) else {
        //                        print("Failed getting data from url: \(selectedFileURL)")
        //                        return
        //                    }
        //                    guard let algorithm = try? JSONDecoder().decode(Algorithm.self, from: data) else {
        //                        print("Failed decoding file.")
        //                        return
        //                    }
        //                    defer {
        //                        selectedFileURL.stopAccessingSecurityScopedResource()
        //                    }
        //                    withAnimation {
        //                        viewModel.addImportedAlgorithm(algorithm: algorithm)
        //                    }
        //                    print("Algorithm imported successfully")
        //                } else {
        //                    print("Error occupied. Failed accessing security scoped resource.")
        //                }
        //            } catch {
        //                print("Error occupied: \(error.localizedDescription)")
        //            }
        //        }
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
    
    private var userHelpButton: some View {
        NavigationLink {
            UserHelpView()
        } label: {
            Image(systemName: "questionmark.circle")
        }
    }
    
    private func wrappedAlgorithmsView(_ folder: Folder) -> some View {
        ZStack {
            if folder.wrappedAlgorithms.isEmpty {
                Text("No Algorithms")
                    .foregroundColor(.secondary)
                    .font(.title2)
            } else {
                algorithmsList
            }
            AddAlgorithmView(folder: folder)
        }
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarLeading) {
                userHelpButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        showEditSheet.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .popover(isPresented: $showEditSheet) {
                    AlgorithmEditView(showEditView: $showEditSheet, sorting: $sorting, sortingOrder: $sortingOrder, folder: folder)
                        .frame(
                            width: UIDevice.current.userInterfaceIdiom == .pad
                            ? UIScreen.main.bounds.width / 2.5
                            : nil,
                            height: UIDevice.current.userInterfaceIdiom == .pad
                            ? 320
                            : nil
                        )
                }
            }
        }
    }
    
    private var algorithmsList: some View {
        List(searchResults, selection: $listSelection) { algorithm in
            NavigationLink(destination: AlgorithmView(), tag: algorithm, selection: $viewModel.selectedAlgorithm) {
                customCell(algorithm)
            }
            .onTapGesture {
                withAnimation {
                    viewModel.selectedAlgorithm = algorithm
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) {
                    withAnimation {
                        viewModel.selectedAlgorithm = nil
                        viewModel.deleteAlgorithm(algorithm)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                }
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
}
