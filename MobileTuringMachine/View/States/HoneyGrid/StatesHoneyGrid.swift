//
//  StatesHoneyGrid.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 16.06.2022.
//

import SwiftUI

struct StatesHoneyGrid: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State var isBeingEdited: Bool = false
    @State private var rows: [[StateQ]] = []
    
    let algorithm: Algorithm
    let width = UIScreen.main.bounds.width - 30
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: -10) {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: 10) {
                        ForEach(rows[rowIndex]) { state in
                            StateHoneyGridCell(isBeingEdited: $isBeingEdited, state: state)
                                .frame(width: 110, height: 110)
                                .offset(x: getOffset(index: rowIndex))
                        }
                    }
                }
            }
            .padding()
            .frame(width: width)
        }
        .onAppear {
            withAnimation {
                generateHoney()
            }
        }
        .onChange(of: algorithm.wrappedStates) { newValue in
            withAnimation {
                generateHoney()
            }
        }
        .navigationTitle("States")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        viewModel.addState(algorithm: algorithm)
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        isBeingEdited.toggle()
                    }
                } label: {
                    Text(isBeingEdited ? "Done" : "Edit")
                }
            }
        }
    }
}

struct StatesHoneyGrid_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        viewModel.addFolder(name: "Algorithms")
        let folder = viewModel.dataManager.savedFolders[0]
        for algorithm in folder.wrappedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm(to: folder)
        let algorithm = folder.wrappedAlgorithms[0]
        
        return StatesHoneyGrid(algorithm: algorithm)
            .environmentObject(AlgorithmViewModel())
    }
}

extension StatesHoneyGrid {
    private func getOffset(index: Int) -> CGFloat {
        let current = rows[index].count
        
        let offset: CGFloat = (375 - 20) / 3 / 2
        
        if index != 0 {
            let previous = rows[index - 1].count
            
            if current == 1 && previous == 3 {
                return -offset
            }
            
            if current == previous {
                return -offset
            }
        }
        return 0
    }
    
    private func generateHoney() {
        rows.removeAll()
        var count = 0
        
        var generated: [StateQ] = []
        for state in algorithm.wrappedStates {
            generated.append(state)
            
            if generated.count == 2 {
                if let last = rows.last {
                    if last.count == 3 {
                        rows.append(generated)
                        generated.removeAll()
                    }
                }
                
                if rows.isEmpty {
                    rows.append(generated)
                    generated.removeAll()
                }
            }
            if generated.count == 3 {
                if let last = rows.last {
                    if last.count == 2 {
                        rows.append(generated)
                        generated.removeAll()
                    }
                }
            }
            
            count += 1
            // for exhaust data or single data
            if count == algorithm.wrappedStates.count && !generated.isEmpty {
                rows.append(generated)
            }
        }
    }
}
