//
//  InfoPopupView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.06.2022.
//

import SwiftUI

struct InfoPopupView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "play.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Spacer()
                Text("Auto play")
            }
            Divider()
            HStack {
                Image(systemName: "forward.frame.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Spacer()
                Text("Make a step")
            }
            Divider()
            HStack {
                Image(systemName: "stop.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                Spacer()
                Text("Reset tapes to start configurations")
            }
        }
            .padding()
            .background(Color.secondaryBackground)
            .cornerRadius(12)
            .shadow(radius: 10)
    }
}

struct InfoPopupView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPopupView()
    }
}
