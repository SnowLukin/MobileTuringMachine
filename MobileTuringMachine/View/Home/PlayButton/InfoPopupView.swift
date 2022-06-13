//
//  InfoPopupView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.06.2022.
//

import SwiftUI

struct InfoPopupView: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "play.fill")
                    .foregroundColor(.blue)
                Spacer()
                Text("Auto play")
            }.font(.title2)
            
            HStack {
                Image(systemName: "forward.frame.fill")
                    .foregroundColor(.blue)
                Spacer()
                Text("Make a step")
            }.font(.title2)
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
