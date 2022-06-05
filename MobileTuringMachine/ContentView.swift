//
//  ContentView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        addTapeButton
                        tapes
                        Spacer()
                    }.padding()
                }
                
                configStatesNavigationLink
            }
            .navigationTitle("Turing Machine")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(TapeContentViewModel())
            
    }
}

extension ContentView {
    
    private var addTapeButton: some View {
        Button {
            viewModel.addTape()
        } label: {
            buttonView("Add Tape")
        }.padding()
    }
    
    private var tapes: some View {
        ForEach(viewModel.tapes) { tape in
            TapeViewConfigTapesView(tapeID: tape.id)
        }
    }
    
    private var configStatesNavigationLink: some View {
        VStack {
            Spacer()
//            NavigationLink(destination: SolveView()) {
//                buttonView("Config States")
//                    .padding().padding()
//            }
        }
    }
    
    private func buttonView(_ text: String) -> some View {
        ZStack {
            Color.secondaryBackground
            Text(text)
                .foregroundColor(.primary)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .cornerRadius(10)
        .frame(height: 50)
    }
}
