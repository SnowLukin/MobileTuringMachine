//
//  UserHelpView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 30.06.2022.
//

import SwiftUI

struct UserHelpView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                algorithmsInfo
                insideAlgorithmInfo
                insideAlgorithmInfo2
                tapes
                states
            }
        }.frame(width: UIScreen.main.bounds.width * 0.9)
            .navigationTitle("Instructions")
    }
}

struct UserHelpView_Previews: PreviewProvider {
    static var previews: some View {
        UserHelpView()
    }
}

extension UserHelpView {
    private var algorithmsInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Algorithms")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.vertical, 2)
            HStack {
                Spacer()
                Image(colorScheme == .dark ? "algorithms_dark" : "algorithms")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                Spacer()
            }
            Text("In this section you can create multiple algorithms.")
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
                    .font(.title3)
                Text(" - add new multiline Turing machine algorithm.")
            }
            HStack {
                Text("Edit")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                Text(" - moving or deleting algorithms")
            }
            Divider()
        }
    }
    
    private var insideAlgorithmInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Inside the algorithm")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.vertical, 2)
            HStack {
                Spacer()
                Image(colorScheme == .dark ? "algorithm_dark" : "algorithm")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                Spacer()
            }
            Text("This is your workspace. Here you can configure tapes, states, and try your algorithm.")
            HStack(spacing: 0) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                Text(" - open algorithm information such as name and description.")
            }
            HStack {
                Text("Show setting")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                Text(" - show algorithm configuration.")
            }
            
        }
    }
    
    private var insideAlgorithmInfo2: some View {
        VStack(alignment: .leading) {
            Text("Here you can choose what you want to configure.")
            HStack {
                Text("To make your algorithm working open play menu: ")
                ZStack {
                    Circle().frame(width: 30, height: 30)
                        .foregroundColor(Color.secondaryBackground)
                        .shadow(radius: 1)
                    Image(systemName: "chevron.up")
                        .foregroundColor(.blue)
                        .font(.body.bold())
                }
            }
            Text("Here you can choose one of two options:")
            HStack(spacing: 0) {
                ZStack {
                    Circle().frame(width: 30, height: 30)
                        .foregroundColor(Color.secondaryBackground)
                        .shadow(radius: 1)
                    Image(systemName: "play.fill")
                        .foregroundColor(.blue)
                        .font(.body.bold())
                }.padding(.leading, 1)
                Text(" - start autoplay.")
            }
            HStack(spacing: 0) {
                ZStack {
                    Circle().frame(width: 30, height: 30)
                        .foregroundColor(Color.secondaryBackground)
                        .shadow(radius: 1)
                    Image(systemName: "forward.frame.fill")
                        .foregroundColor(.blue)
                        .font(.body.bold())
                }.padding(.leading, 1)
                Text(" - make a step.")
            }
            Text("In order to enable algorithm configuration after performing actions with tapes you need to reset algorithm to its state before actions.")
            HStack(spacing: 0) {
                ZStack {
                    Circle().frame(width: 30, height: 30)
                        .foregroundColor(Color.secondaryBackground)
                        .shadow(radius: 1)
                    Image(systemName: "stop.fill")
                        .foregroundColor(.red)
                        .font(.body.bold())
                }.padding(.leading, 1)
                Text(" - reset algorithm.")
            }
            Divider()
        }
    }
    
    private var tapes: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Configuring tapes")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.vertical, 2)
            
            HStack {
                Spacer()
                Image(colorScheme == .dark ? "tapes_dark" : "tapes")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                Spacer()
            }
            Text("Here you can add, remove and configure tapes.")
            HStack(spacing: 0) {
                Text("Show")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                Text(" - show tape components or get access to removing the tape.")
            }
            
            HStack {
                Text("To open the section where you can configure alhabet and input press ")
                ZStack {
                    Circle().frame(width: 30, height: 30)
                        .foregroundColor(Color.secondaryBackground)
                        .shadow(radius: 1)
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .font(.body.bold())
                }.padding(.leading, 1)
            }
            Divider()
        }
    }
    
    private var states: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Configuring states")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.vertical, 2)
            
            HStack {
                Spacer()
                Image(colorScheme == .dark ? "states_dark" : "states")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                Spacer()
            }
            Text("Here you can add, remove and configure states.")
            
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
                    .font(.title3)
                Text(" - add new state.")
            }
            HStack {
                Text("Edit")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                Text(" - choose state to delete.")
            }
            Text("When state tapped, you get access to every possible combination of the multiline Turing machine.")
            HStack {
                Spacer()
                Image(colorScheme == .dark ? "combinations_dark" : "combinations")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                Spacer()
            }
            Text("When combination's picked you can configure the action for every tape. Also you can configure the state which will be next after current combination is completed.")
            HStack {
                Spacer()
                Image(colorScheme == .dark ? "combination_dark" : "combination")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                Spacer()
            }
        }
    }
}

