//
//  CustomAlgorithmButton.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.07.2022.
//

import SwiftUI

struct CustomAlgorithmButton: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var showMoveAlgorithmSheet = false
    @Binding var editMode: EditMode
    
    let algorithm: Algorithm
    
    var body: some View {
        Button {
            viewModel.selectedAlgorithm = algorithm
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(algorithm.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(viewModel.getAlgorithmEditedTimeForTextView(algorithm))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .contextMenu {
            if editMode == .inactive {
                // Pin
                Button {
                    withAnimation {
                        viewModel.togglePinAlgorithm(algorithm)
                    }
                } label: {
                    Label(algorithm.pinned ? "Unpin algorithm" : "Pin Algorithm", systemImage: algorithm.pinned ? "pin.slash" : "pin")
                }
                // Move
                Button {
                    withAnimation {
                        showMoveAlgorithmSheet.toggle()
                    }
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
        .sheet(isPresented: $showMoveAlgorithmSheet) {
            let chosenFolder = algorithm.folder
            MoveFolderView(
                folder: chosenFolder,
                algorithms: [algorithm], editMode: $editMode
            )
        }
    }
}

