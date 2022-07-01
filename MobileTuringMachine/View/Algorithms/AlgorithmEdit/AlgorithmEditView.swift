//
//  AlgorithmEditView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 01.07.2022.
//

import SwiftUI

struct AlgorithmEditView: View {
    @Binding var showEditView: Bool
    
    let folderName: String = "Algorithms"
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                folder
                Spacer()
                dismissButton
            }
            .padding(.top)
            .padding(.horizontal)
            Form {
                importButton
                Section {
                    galleryButton
                    selectButton
                    sortButton
                }
            }
            .onAppear {
                UITableView.appearance().sectionFooterHeight = 0
            }
        }
        .background(Color.secondaryBackground)
    }
}

struct AlgorithmEditView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(true) {
            AlgorithmEditView(showEditView: $0)
        }
    }
}

extension AlgorithmEditView {
    
    private var importButton: some View {
        Button {
            
        } label: {
            HStack {
                Text("Import Algorithm")
                Spacer()
                Image(systemName: "square.and.arrow.down")
            }
        }.foregroundColor(.primary)
    }
    
    private var selectButton: some View {
        Button {
            
        } label: {
            HStack {
                Text("Select Algorithms")
                Spacer()
                Image(systemName: "checkmark.circle")
            }.foregroundColor(.primary)
        }
    }
    
    private var sortButton: some View {
        Button {
            
        } label: {
            HStack {
                Text("Sort Algorithms By Name")
                Spacer()
                Image(systemName: "arrow.up.arrow.down")
            }.foregroundColor(.primary)
        }
    }
    
    private var galleryButton: some View {
        Button {
            
        } label: {
            HStack {
                Text("View as Gallery")
                Spacer()
                Image(systemName: "square.grid.2x2")
            }.foregroundColor(.primary)
        }
    }
    private var folder: some View {
        HStack {
            Image(systemName: "folder.fill")
                .symbolRenderingMode(.multicolor)
                .font(.largeTitle)
            Text(folderName)
                .fontWeight(.semibold)
        }
    }
    
    private var dismissButton: some View {
        Button {
            withAnimation {
                showEditView.toggle()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.footnote.bold())
                .foregroundColor(.secondary)
                .padding(6)
                .background(
                    Color.gray.brightness(0.3)
                )
                .clipShape(Circle())
                .offset(y: -15)
        }
    }
}
