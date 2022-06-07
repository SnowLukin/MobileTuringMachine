//
//  ConfigurationsView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 07.06.2022.
//

import SwiftUI

struct ConfigurationsView: View {
    @EnvironmentObject private var viewModel: TapeContentViewModel
    @State private var showSettings = false
    
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    showSettings.toggle()
                }
            } label: {
                Text(showSettings ? "Hide settings" : "Show settings")
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.secondaryBackground)
            .cornerRadius(12)
            .padding([.leading, .trailing])
            
            if showSettings {
                VStack {
                    customSection(header: "Configurations", content: AnyView(customTwoCells))
                    customSection(header: "Starting state", content: AnyView(customCell))
                }.padding([.top, .bottom])
            }
        }.background(Color.secondaryBackground)
    }
}

struct ConfigurationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationsView()
            .environmentObject(TapeContentViewModel())
    }
}


extension ConfigurationsView {
    
    private func customSection(header: String = "", content: AnyView) -> some View {
        VStack(spacing: 6) {
            customHeaderView(header)
            content
        }
    }
    
    private var customCell: some View {
        VStack {
            customCellButtonView("State \(viewModel.startState)", destination: AnyView(ChooseStartStateView()))
        }.padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.background)
            .cornerRadius(12)
            .padding([.leading, .trailing])
    }
    
    private var customTwoCells: some View {
        VStack(alignment: .leading, spacing: 7) {
            customCellButtonView("Tapes", destination: AnyView(Tapes()))
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 5)
            Divider()
                .padding(.leading)
            customCellButtonView("States", destination: AnyView(StatesView()))
                .padding(.top, 5)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.background)
        .cornerRadius(12)
        .padding([.leading, .trailing])
    }
    
    private func customHeaderView(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
        }.padding([.leading, .trailing], 35)
    }
    
    // TODO: Get rid of AnyView
    private func customCellButtonView(_ text: String, destination: AnyView) -> some View {
        NavigationLink {
            destination
        } label: {
            Text(text)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.primary)
        }.padding([.leading, .trailing])
    }
}