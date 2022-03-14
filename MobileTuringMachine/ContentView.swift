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
            ScrollView {
                VStack {
                    tapesAmountButton
                        .padding()
                    ForEach(viewModel.tapes) { tape in
                        TapeViewConfigTapesView(tapeID: tape.id)
                    }
                    Spacer()
                }.padding()  
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
    
    private var tapesAmountButton: some View {
        Button {
            viewModel.addTape()
        } label: {
            ZStack {
                Color.secondaryBackground
                Text("Add Tape")
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .cornerRadius(10)
            
        }.frame(height: 50)
    }
    
}
