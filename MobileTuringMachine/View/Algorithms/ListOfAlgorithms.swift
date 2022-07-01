//
//  ListOfAlgorithms.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI

struct ListOfAlgorithms: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var searchText = ""
    @State private var showInfo = false
    @State private var showEditSheet = false
//    @State private var openFile = false
    @State private var sorting: Sortings = .name
    @State private var sortingOrder: SortingOrder = .up
    
    var searchResults: [Algorithm] {
        viewModel.getSearchResult(searchText, sorting: sorting, sortingOrder: sortingOrder)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List(searchResults) { algorithm in
                    NavigationLink {
                        AlgorithmView(algorithm: algorithm)
                    } label: {
                        customCell(algorithm)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.deleteAlgorithm(algorithm)
                            }
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                }
                .searchable(text: $searchText)
                AddAlgorithmView()
            }
            .sheetWithDetents(isPresented: $showEditSheet, detents: [.medium(), .large()]) {
                print("Sheet closed")
            } content: {
                AlgorithmEditView(showEditView: $showEditSheet)
            }
            .navigationTitle("Algorithms")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        UserHelpView()
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            showEditSheet.toggle()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
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

struct ListOfAlgorithms_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        return ListOfAlgorithms()
            .environmentObject(AlgorithmViewModel())
    }
}

extension ListOfAlgorithms {
    private func customCell(_ algorithm: Algorithm) -> some View {
        VStack(alignment: .leading) {
            Text(algorithm.name)
                .font(.headline)
            
            if Calendar.current.isDateInYesterday(algorithm.wrappedEditedDate) {
                Text("Yesterday")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text(algorithm.wrappedEditedDate,
                     format: Calendar.current.isDateInToday(algorithm.wrappedEditedDate)
                     ? .dateTime.hour().minute()
                     : .dateTime.day().month().year() 
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }
}
