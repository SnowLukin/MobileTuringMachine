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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ConfigurationsView()
                    TapesWorkView()
                        .shadow(radius: 1)
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        autoPlayButton
                    }
                }
            }
            .navigationTitle("Home")
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
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
    
}
