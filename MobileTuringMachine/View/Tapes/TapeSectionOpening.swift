//
//  TapeSectionOpening.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct TapeSectionOpening: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    @State private var isOpened = false
    
    let tapeID: Int
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Tape \(tapeID)")
                        .font(.system(size: 35).bold())
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        withAnimation {
                            isOpened.toggle()
                        }
                    } label: {
                        Text(isOpened ? "Hide" : "Show")
                    }
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding([.top, .bottom], 9)
                .padding([.leading, .trailing], 30)
                
                if isOpened {
                    TapeViewConfigTapesView(tapeID: tapeID)
                        .shadow(radius: 5)
                        .padding(.bottom)
                }
            }
        }
        .background(Color.secondaryBackground)
        .cornerRadius(12)
        .padding([.leading, .trailing])
    }
}

struct TapeSectionOpening_Previews: PreviewProvider {
    static var previews: some View {
        TapeSectionOpening(tapeID: 0)
            .environmentObject(TapeContentViewModel())
    }
}
