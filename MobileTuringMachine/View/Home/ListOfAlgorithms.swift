//
//  ListOfAlgorithms.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI

struct ListOfAlgorithms: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var showInfo = false
//    @State private var openFile = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.algorithms) { algorithm in
                        NavigationLink {
                            AlgorithmView(algorithm: algorithm)
                        } label: {
                            Text(algorithm.name)
                        }
                    }
                    .onDelete {
                        viewModel.algorithms.remove(atOffsets: $0)
                        for algorithm in viewModel.dataManager.savedAlgorithms {
                            if !viewModel.algorithms.contains(algorithm) {
                                viewModel.deleteAlgorithm(algorithm)
                                break
                            }
                        }
                        viewModel.dataManager.applyChanges()
                    }
                    .onMove {
                        viewModel.algorithms.move(fromOffsets: $0, toOffset: $1)
                        viewModel.dataManager.savedAlgorithms.move(fromOffsets: $0, toOffset: $1)
                        viewModel.dataManager.applyChanges()
                    }
                }
                if showInfo {
                    infoPopup
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                }
            }
            .navigationTitle("Algorithms")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    infoButton
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

extension ListOfAlgorithms {
    private var infoButton: some View {
        Button {
            withAnimation {
                showInfo.toggle()
            }
        } label: {
            Image(systemName: "info.circle")
        }
    }
    
    private var infoPopup: some View {
        VStack {
            InfoPopupView()
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        showInfo.toggle()
                    }
                }
        )
    }
}
