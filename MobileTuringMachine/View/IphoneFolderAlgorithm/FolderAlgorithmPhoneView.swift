//
//  FolderAlgorithmPhoneView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 09.07.2022.
//

import SwiftUI

struct FolderAlgorithmPhoneView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var showFolder = true
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(spacing: 0) {
            FolderPhoneView(showMenu: $showFolder, sideBarWidth: width)
            AlgorithmsPhoneView(showFolders: $showFolder)
                .frame(width: width)
        }
        .frame(width: 2 * width)
        .offset(x: showFolder ? width / 2 : -width / 2)
        .onAppear {
            if let _ = viewModel.selectedFolder {
                showFolder = false
            } else {
                showFolder = true
            }
        }
    }
}

struct FolderAlgorithmPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for folder in viewModel.dataManager.savedFolders {
            viewModel.deleteFolder(folder)
        }
        viewModel.addFolder(name: "Algorithms")
        viewModel.addFolder(name: "Second")
        viewModel.addFolder(name: "Third")
        return FolderAlgorithmPhoneView()
            .environmentObject(AlgorithmViewModel())
    }
}
