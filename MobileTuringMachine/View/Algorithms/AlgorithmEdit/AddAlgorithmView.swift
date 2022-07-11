//
//  AddAlgorithmView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 01.07.2022.
//

import SwiftUI

struct AddAlgorithmView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Binding var editMode: EditMode
    @State private var showPopover: Bool = false
    @State private var showCustomSheet: Bool = false
    
    let folder: Folder
    
    var body: some View {
        if showCustomSheet {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showCustomSheet = false
                            editMode = .inactive
                        }
                    }
                iphoneDeleteAllCustomView
            }
        } else {
            VStack {
                Spacer()
                ZStack(alignment: .center) {
                    if editMode == .active {
                        HStack {
                            Button {
                                
                            } label: {
                                Text("Move")
                            }.padding(.horizontal)
                            
                            Spacer()
                            
                            deleteButton
                            
                        }
                    } else {
                        Text("\(folder.wrappedAlgorithms.count) Algorithms")
                            .font(.footnote)
                        addAlgorithmButton
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 60)
                .overlay(Divider(), alignment: .top)
                .background(Color.secondaryBackground)
            }
        }
    }
}

struct AddAlgorithmView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        return AddAlgorithmView(editMode: .constant(.inactive), folder: folder)
            .environmentObject(AlgorithmViewModel())
    }
}

extension AddAlgorithmView {
    private var addAlgorithmButton: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    viewModel.addAlgorithm(to: folder)
                }
            } label: {
                Image(systemName: "doc.badge.plus")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(.trailing)
            }
        }
    }
    
    private var deleteButton: some View {
        Button {
            if !viewModel.listSelection.isEmpty {
                withAnimation {
                    for algorithm in viewModel.listSelection {
                        if viewModel.selectedAlgorithm == algorithm {
                            viewModel.selectedAlgorithm = nil
                        }
                        viewModel.deleteAlgorithm(algorithm)
                    }
                    editMode = .inactive
                    viewModel.listSelection = []
                }
            } else {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    withAnimation {
                        showPopover = true
                    }
                } else {
                    withAnimation {
                        showCustomSheet = true
                    }
                }
            }
        } label: {
            Text(!viewModel.listSelection.isEmpty ? "Delete" : "Delete All")
        }
        .padding(.horizontal)
        .popover(isPresented: $showPopover) {
            Button(role: .destructive) {
                withAnimation {
                    viewModel.selectedAlgorithm = nil
                    for algorithm in folder.wrappedAlgorithms {
                        viewModel.deleteAlgorithm(algorithm)
                    }
                    showPopover = false
                    editMode = .inactive
                }
            } label: {
                Text("Delete All")
                    .font(.title3)
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .frame(width: 300)
            }
        }
    }
    
    private var iphoneDeleteAllCustomView: some View {
        VStack {
            Spacer()
            Button(role: .destructive) {
                withAnimation {
                    viewModel.selectedAlgorithm = nil
                    for algorithm in folder.wrappedAlgorithms {
                        viewModel.deleteAlgorithm(algorithm)
                    }
                    showCustomSheet = false
                    editMode = .inactive
                }
            } label: {
                Text("Delete All")
                    .foregroundColor(.red)
                    .font(.title3)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 60)
            .background(
                colorScheme == .dark
                ? Color.secondaryBackground.opacity(0.7)
                : Color.background.opacity(0.7)
            )
            .cornerRadius(12)
            
            Button(role: .cancel) {
                withAnimation {
                    showCustomSheet = false
                    editMode = .inactive
                }
            } label: {
                Text("Cancel")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 60)
            .background(
                colorScheme == .dark
                ? Color.secondaryBackground
                : Color.background
            )
            .cornerRadius(12)
        }.padding()
    }
}
