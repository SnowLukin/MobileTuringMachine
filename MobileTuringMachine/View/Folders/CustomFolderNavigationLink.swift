//
//  CustomFolderNavigationLink.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 14.07.2022.
//

import SwiftUI

struct CustomFolderNavigationLink: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var showPopover = false
    @Binding var editMode: EditMode
    @Binding var selectedFolder: Folder?
    let folder: Folder
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    viewModel.selectedFolder = folder
                } label: {
                    HStack {
                        Label {
                            Text(folder.name)
                                .foregroundColor(
                                    editMode == .active && folder.name == "Algorithms"
                                    ? .secondary
                                    : .primary
                                )
                        } icon: {
                            Image(systemName: "folder")
                                .foregroundColor(
                                    editMode == .active && folder.name == "Algorithms"
                                    ? .secondary
                                    : .orange
                                )
                                .font(.title2)
                        }
                        Spacer()
                        Text("\(folder.wrappedAlgorithms.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }.disabled(
                    editMode == .active && folder.name == "Algorithms"
                )
                if editMode == .active && folder.name != "Algorithms" {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.blue)
                        .transition(.scale)
                        .onTapGesture {
                            withAnimation {
                                showPopover = true
                            }
                        }
                        .popover(isPresented: $showPopover) {
                            FolderPopoverView(editMode: $editMode, showCurrentPopover: $showPopover, folder: folder)
                                .frame(
                                    width: UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width / 2.5 : nil,
                                    height: UIDevice.current.userInterfaceIdiom == .pad ? 300 : nil
                                )
                        }
                }
            }
        }
    }
}

struct CustomFolderNavigationLinkPhone: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var showFolderPopover = false
    @Binding var showMenu: Bool
    @Binding var editMode: EditMode
    
    
    let folder: Folder
    
    var body: some View {
        ZStack {
            Button {
                withAnimation {
                    viewModel.selectedFolder = folder
                    showMenu.toggle()
                }
            } label: {
                HStack {
                    Label {
                        Text(folder.name)
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "folder")
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    if editMode == .active {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.blue)
                            .transition(.slide)
                            .onTapGesture {
                                withAnimation {
                                    showFolderPopover.toggle()
                                }
                            }
                            .sheet(isPresented: $showFolderPopover) {
                                FolderPopoverView(editMode: $editMode, showCurrentPopover: $showFolderPopover, folder: folder)
                            }
                    }
                }
            }
        }
    }
}
