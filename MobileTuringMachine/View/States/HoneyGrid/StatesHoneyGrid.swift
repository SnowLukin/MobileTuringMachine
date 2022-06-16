//
//  StatesHoneyGrid.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 16.06.2022.
//

import SwiftUI

struct StatesHoneyGrid: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State var isBeingEdited: Bool = false
    @State private var rows: [[StateQ]] = []
    let width = UIScreen.main.bounds.width - 30
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: -10) {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: 10) {
                        ForEach(rows[rowIndex]) { state in
                            StateHoneyGridCell(isBeingEdited: $isBeingEdited, state: state)
                                .frame(width: (width - 20) / 3.2, height: 110)
                                .shadow(radius: 5)
                                .offset(x: getOffset(index: rowIndex))
                                .transition(.asymmetric(insertion: .scale, removal: .opacity))
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
        .onChange(of: viewModel.states, perform: { newValue in
            withAnimation {
                generateHoney()
            }
        })
        .navigationTitle("States")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.spring()) {
                        viewModel.addState()
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
        StatesHoneyGrid()
            .environmentObject(TapeContentViewModel())
    }
}

extension StatesHoneyGrid {
    private func getOffset(index: Int) -> CGFloat {
        let current = rows[index].count
        
        let offset = ((width - 20) / 3) / 2
        
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
        for state in viewModel.states {
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
            if count == viewModel.states.count && !generated.isEmpty {
                rows.append(generated)
            }
        }
    }
}
