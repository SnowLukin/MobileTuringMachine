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
                        startButton
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TapeContentViewModel())
    }
}

extension HomeView {
    
    private var startButton: some View {
        Button {
            withAnimation {
                isPlaying.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                while isPlaying {
                    viewModel.startWork()
                }
            }
//            DispatchQueue.main.async {
//                while isPlaying {
//                    viewModel.startWork()
//                }
//            }
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
