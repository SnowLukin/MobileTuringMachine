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
//    @State private var openFile = false
    
    var searchResults: [Algorithm] {
        if searchText.isEmpty {
            return DataManager.shared.savedAlgorithms
        } else {
            return DataManager.shared.savedAlgorithms.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List(searchResults) { algorithm in
                    NavigationLink {
                        AlgorithmView(algorithm: algorithm)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(algorithm.name)
                                .font(.headline)
                            Text("23.09.2022")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
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
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        withAnimation {
//                            openFile.toggle()
//                        }
//                    } label: {
//                        Image(systemName: "square.and.arrow.down")
//                    }
//                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.addAlgorithm()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
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
        ListOfAlgorithms()
            .environmentObject(AlgorithmViewModel())
    }
}
