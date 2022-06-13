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
    @State private var showInfo: Bool = false
    
    var body: some View {
        ZStack {
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
                            infoButton
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        }
                        playOptionButton
                    }.zIndex(1)
                        .padding(30)
                }
            }
            if showInfo {
                infoPopup.zIndex(2)
                    // Wtf Tim Cook? Why i have to write so many letters?
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if isPlaying {
                viewModel.makeStep()
                autoPlay()
            }
        }
    }
    
    private func makeStep() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
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
                .frame(width: 60, height: 60)
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
            Image(systemName: isPlayOptionOn ? "chevron.down" : "chevron.up")
                .font(.title2.bold())
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .background(Color.secondaryBackground)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
    
    private var makeStepButton: some View {
        Button {
            makeStep()
        } label: {
            Image(systemName: "forward.frame.fill")
                .font(.title2)
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .background(Color.secondaryBackground)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
    
    private var infoButton: some View {
        Button {
            withAnimation {
                showInfo.toggle()
            }
        } label: {
            Image(systemName: "info")
                .font(.title2.bold())
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .background(Color.secondaryBackground)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
    
    private var infoPopup: some View {
        VStack {
            InfoPopupView()
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        showInfo.toggle()
                    }
                }
        )
    }
}
