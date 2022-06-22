//
//  AlgorithmView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI

struct AlgorithmView: View {
    @EnvironmentObject private var viewModel: AlgorithmViewModel
    @State private var isChanged = false
    @State private var showSettings = false
    @State private var showInfo = false
    
    let algorithm: Algorithm
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ConfigurationsView(showSettings: $showSettings, algorithm: algorithm)
                        .disabled(isChanged)
                    if isChanged {
                        Text("Reset to enable configurations")
                            .font(.body)
                            .foregroundColor(.red)
                    }
                    TapesWorkView(algorithm: algorithm)
                        .shadow(radius: 1)
                }.zIndex(1)
                PlayStack(isChanged: $isChanged, algorithm: algorithm).zIndex(2)
                
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

struct AlgorithmView_Previews: PreviewProvider {
    static var previews: some View {
        AlgorithmView(algorithm:
                        Algorithm(
                            name: "New Algorithm",
                            tapes: [],
                            states: [],
                            stateForReset:
                                StateQ(
                                    nameID: 0,
                                    options: []
                                )
                        )
        )
    }
}

extension AlgorithmView {
    
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
