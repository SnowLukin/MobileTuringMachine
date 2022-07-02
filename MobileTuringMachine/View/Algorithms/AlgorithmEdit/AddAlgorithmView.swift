//
//  AddAlgorithmView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 01.07.2022.
//

import SwiftUI

struct AddAlgorithmView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .center) {
                Text("\(viewModel.dataManager.savedAlgorithms.count) Algorithms")
                    .font(.footnote)
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.addAlgorithm()
                        }
                    } label: {
                        Image(systemName: "doc.badge.plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 40)
            .overlay(Divider(), alignment: .top)
            .background(Color.secondaryBackground)
        }
    }
}

struct AddAlgorithmView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AlgorithmViewModel()
        for algorithm in viewModel.dataManager.savedAlgorithms {
            viewModel.deleteAlgorithm(algorithm)
        }
        viewModel.addAlgorithm()
        return AddAlgorithmView()
            .environmentObject(AlgorithmViewModel())
    }
}
