//
//  PlayStack.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.06.2022.
//

import SwiftUI

struct PlayStack: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var isPlaying: Bool = false
    @State private var isPlayOptionOn: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    if isPlayOptionOn {
                        playButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        makeStepButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        resetButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                    }
                    playOptionButton
                }.padding(30)
            }
        }
    }
}

struct PlayStack_Previews: PreviewProvider {
    static var previews: some View {
        PlayStack()
            .environmentObject(TapeContentViewModel())
    }
}

extension PlayStack {
    
    private func autoPlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if isPlaying {
                viewModel.makeStep()
                autoPlay()
            }
        }
    }
    
    private func makeStep() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            viewModel.makeStep()
        }
    }
    
    private var playButton: some View {
        Button {
            withAnimation {
                isPlaying.toggle()
            }
            autoPlay()
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.title2)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .background(Color.secondaryBackground)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
    
    private var playOptionButton: some View {
        Button {
            withAnimation {
                isPlayOptionOn.toggle()
            }
        } label: {
            Image(systemName: "chevron.up")
                .font(.title2.bold())
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .background(Color.secondaryBackground)
                .clipShape(Circle())
                .shadow(radius: 10)
                .rotationEffect(.degrees(isPlayOptionOn ? -180 : 0))
        }
    }
    
    private var makeStepButton: some View {
        Button {
            makeStep()
        } label: {
            Image(systemName: "forward.frame.fill")
                .font(.title2)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .background(Color.secondaryBackground)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
    
    private var resetButton: some View {
        // TODO: Add reset action
        Button {
            
        } label: {
            Image(systemName: "stop.fill")
                .font(.title2)
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .background(Color.secondaryBackground)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}
