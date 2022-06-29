//
//  TestStateList.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 29.06.2022.
//

import SwiftUI

struct TestStateList: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    let algorithm: Algorithm
    
    var body: some View {
        List {
            ForEach(algorithm.wrappedStates) { state in
                //                NavigationLink {
                ////                    CombinationsListView(state: state)
                //                } label: {
                //                    Text("\(state.nameID)")
                //                }
                TestStateList2(state: state)
            }
            .onDelete {
                if let index = $0.first {
                    print(index)
                    viewModel.deleteState(algorithm.wrappedStates[index])
                }
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
                        viewModel.deleteState(algorithm.wrappedStates[1])
                    }
                } label: {
                    Image(systemName: "minus")
                }
            }
        }
    }
}

struct TestStateList_Previews: PreviewProvider {
    static var previews: some View {
        let algorithm = DataManager.shared.savedAlgorithms[0]
        TestStateList(algorithm: algorithm)
            .environmentObject(AlgorithmViewModel())
    }
}

struct TestStateList2: View {
    
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    let state: StateQ
    
    var body: some View {
        Text("\(state.nameID)")
    }
}
