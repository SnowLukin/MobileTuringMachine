//
//  TapeView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    let tape: Tape
    
    var layout: [GridItem] = [
        GridItem(.flexible(minimum: 25))
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                tapeGrid
                    .onAppear {
                        withAnimation {
                            value.scrollTo(tape.headIndex, anchor: .center)
                        }
                    }
                    .onChange(of: tape.headIndex) { newValue in
                        withAnimation {
                            value.scrollTo(newValue, anchor: .center)
                        }
                    }
            }
        }
        .frame(height: 40)
        .background(Color.secondaryBackground)
        .cornerRadius(9)
    }
}

struct TapeView_Previews: PreviewProvider {
    static var previews: some View {
        TapeView(tape: Tape(nameID: 0, components: [TapeContent(id: 0)]))
            .environmentObject(TapeContentViewModel())
            .preferredColorScheme(.dark)
            .padding()
    }
}


extension TapeView {
    
    private var tapeGrid: some View {
        LazyHGrid(rows: layout) {
            ForEach(tape.components) { component in
                TapeContentView(component: component, tape: tape)
            }
        }
        .padding(.horizontal)
    }
}
