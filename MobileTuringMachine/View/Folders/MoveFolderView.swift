//
//  MoveFolderView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 14.07.2022.
//

import SwiftUI

struct MoveFolderView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    @Binding var editMode: EditMode
    
    let folder: Folder
    let algorithms: [Algorithm]?
    
    init(folder: Folder, algorithms: [Algorithm]? = nil, editMode: Binding<EditMode>) {
        self.folder = folder
        self.algorithms = algorithms
        self._editMode = editMode
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if let algorithms = algorithms {
                        Image(systemName: "doc.text.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.blue)
                            .brightness(-0.3)
//                            .symbolRenderingMode(.multicolor)
                        VStack(spacing: 5) {
                            HStack {
                                if algorithms.count > 6 {
                                    ForEach(0..<6, id: \.self) { algorithmIndex in
                                        if algorithmIndex < 5 {
                                            Text("\(algorithms[algorithmIndex].name), ")
                                                .lineLimit(1)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                                .padding(5)
                                        } else {
                                            Text("\(algorithms[algorithmIndex].name)")
                                                .lineLimit(1)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    Text("& \(algorithms.count - 6) more")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(5)
                                } else {
                                    ForEach(0..<algorithms.count, id: \.self) { algorithmIndex in
                                        if algorithmIndex < algorithms.count - 1 {
                                            Text("\(algorithms[algorithmIndex].name), ")
                                                .lineLimit(1)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                        } else {
                                            Text("\(algorithms[algorithmIndex].name)")
                                                .lineLimit(1)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                            }
                            Text("Current folder: \(folder.name)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    } else {
                        Image(systemName: "folder.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.multicolor)
                        VStack {
                            Text(folder.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("\(folder.wrappedAlgorithms.count) algorithms")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                List(viewModel.dataManager.savedFolders.filter { $0.parentFolder == nil }, children: \.optionalSubFolders) { toFolder in
                    Button {
                        if let algorithms = algorithms {
                            viewModel.moveAlgorithms(algorithms, to: toFolder)
                        } else {
                            viewModel.moveFolder(folder, to: toFolder)
                        }
                        presentationMode.wrappedValue.dismiss()
                        editMode = .inactive
                    } label: {
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(
                                    toFolder == folder
                                    ? .secondary
                                    : .orange
                                )
                            Text(toFolder.name)
                                .foregroundColor(
                                    toFolder == folder
                                    ? .secondary
                                    : .primary
                                )
                            Spacer()
                        }
                    }
                    .disabled(toFolder == folder)
                }
            }
            .background(
                colorScheme == .dark
                ? Color.secondaryBackground
                : Color.background
            )
            .navigationTitle("Select a folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct MoveFolderView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for folder in viewModel.dataManager.savedFolders {
            viewModel.deleteFolder(folder)
        }
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        return MoveFolderView(folder: folder, editMode: .constant(.active))
            .environmentObject(AlgorithmViewModel())
    }
}

