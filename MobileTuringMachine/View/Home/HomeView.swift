//
//  HomeView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var isChanged = false
    @State private var showSettings = false
    @State private var showInfo = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ConfigurationsView(showSettings: $showSettings)
                        .disabled(isChanged)
                    if isChanged {
                        Text("Reset to enable configurations")
                            .font(.body)
                            .foregroundColor(.red)
                    }
                    TapesWorkView()
                        .shadow(radius: 1)
                }.zIndex(1)
                PlayStack(isChanged: $isChanged).zIndex(2)
                
                if showInfo {
                    infoPopup.zIndex(3)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                }
            }
            .navigationTitle("Turing Machine")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    infoButton
                }
            }
            .onChange(of: isChanged) { _ in
                if isChanged {
                    withAnimation {
                        showSettings = false
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TapeContentViewModel())
    }
}

extension HomeView {
    
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
