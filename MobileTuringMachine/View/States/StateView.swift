//
//  StateView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.06.2022.
//

import SwiftUI

struct StateView: View {
    
    @EnvironmentObject private var viewModel: TapeContentViewModel
    
    @State var animationBool = true
    @Binding var isBeingEdited: Bool
    
    let stateID: Int
    
    var body: some View {
        if stateID == viewModel.states.count {
            addStateButton
        } else {
            stateNavigationButton
                .rotationEffect(.degrees(isBeingEdited ? 3.5 : 0))
                .animation(
                    isBeingEdited
                    ? .easeInOut(duration: 0.15).repeatForever(autoreverses: true)
                    : .easeInOut(duration: 0.15),
                    value: isBeingEdited
                )
                .disabled(isBeingEdited)
                .opacity(isBeingEdited ? 0.7 : 1)
                .overlay(
                    removeCircleButton
                )
        }
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(true) {
            StateView(isBeingEdited: $0, stateID: 0)
                .environmentObject(TapeContentViewModel())
        }
    }
}

extension StateView {
    
    private var addStateButton: some View {
        Button {
            withAnimation {
                viewModel.addState()
            }
        } label: {
            Image(systemName: "plus")
                .font(.subheadline.bold())
                .foregroundColor(.primary)
                .padding()
                .frame(width: 98, height: 56)
                .background(Color.secondaryBackground)
                .cornerRadius(12)
        }
        .padding(.top)
        .disabled(isBeingEdited)
        .opacity(isBeingEdited ? 0.7 : 1)
    }
    
    private var stateNavigationButton: some View {
        NavigationLink(destination: CombinationsListView(stateID: stateID)) {
            Text("State \(stateID)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding()
                .background(Color.secondaryBackground)
                .cornerRadius(12)
        }
        .padding(.top)
    }
    
    private var removeCircleButton: some View {
        Button {
            viewModel.removeState(atID: stateID)
        } label: {
            Image(systemName: "minus.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.title2)
        }
            .disabled(!isBeingEdited || viewModel.states.count == 1)
            .offset(x: -43, y: -17)
            .opacity(isBeingEdited ? (viewModel.states.count != 1 ? 1 : 0.7) : 0)
    }
    
}
