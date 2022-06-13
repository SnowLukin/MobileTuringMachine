//
//  HomeView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var isPlaying = false
    @State private var showInfo = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ConfigurationsView()
                    TapesWorkView()
                        .shadow(radius: 1)
                }.zIndex(1)
                PlayStack().zIndex(2)
                
                if showInfo {
                    infoPopup.zIndex(3)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    infoButton
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TapeContentViewModel())
    }
}

extension HomeView {
    
    private func autoPlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if isPlaying {
                viewModel.makeStep()
                autoPlay()
            }
        }
    }
    
    private var autoPlayButton: some View {
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
                .padding(30)
        }
    }
    
    private var infoButton: some View {
        Button {
            withAnimation {
                showInfo.toggle()
            }
        } label: {
            Image(systemName: "info.circle")
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
