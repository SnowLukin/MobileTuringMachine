//
//  TapeView + ConfigTapesView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import SwiftUI

struct TapeViewConfigTapesView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    @State private var isConfigShown = false
    
    let tapeID: Int
    
    var body: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 0) {
                ZStack {
                    HStack {
                        if !isConfigShown {
                            removeButton
                            Spacer()
                        }
                        if isConfigShown {
                            ConfigTapesView(tapeID: tapeID)
                                .padding(.bottom)
                        }
                        configButton
                            .padding(.trailing, 10)
                            .padding(.bottom, 5)
                    }
                }
                TapeView(tapeID: tapeID)
            }.padding(.horizontal)
            
        }
    }
    
}

struct TapeViewConfigTapesView_Previews: PreviewProvider {
    static var previews: some View {
        TapeViewConfigTapesView(tapeID: 0)
            .preferredColorScheme(.dark)
            .environmentObject(TapeContentViewModel())
    }
}

extension TapeViewConfigTapesView {
    
    private var removeButton: some View {
        Button {
            viewModel.removeTape(id: tapeID)
        } label: {
            Text("Remove")
                .animation(.easeInOut, value: !isConfigShown)
        }
//        .disabled(viewModel.tapes.count < 2)

    }
    
    private var configButton: some View {
        Button {
            withAnimation(.default) {
                isConfigShown.toggle()
            }
        } label: {
            ZStack {
                Color.secondaryBackground
                Image(systemName: !isConfigShown ? "plus" : "xmark")
                    .font(.title3)
            }
            .frame(width: 30, height: 30)
            .clipShape(Circle())
        }

    }
    
}
