//
//  SideBarAppView.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.07.2022.
//

import SwiftUI

struct Something: View {
    var body: some View{
            NavigationView{
                List{
                    Section(header: Text("Three columns")){
                        NavigationLink(
                            destination: ItemsView(),
                            label: {
                                Label("Animals",systemImage: "tortoise")
                            })
                        NavigationLink(
                            destination: ItemsView(),
                            label: {
                                Label("Animals 2",systemImage: "hare")
                            })
                    }
                    Section(header: Text("Two columns")){
                        NavigationLink(
                            destination: Text("I want to see here a single view, without detail"),
                            label: {
                                Label("Settings",systemImage: "gear")
                            })
                        NavigationLink(
                            destination: Text("I want to see here a single view, without detail"),
                            label: {
                                Label("Settings 2",systemImage: "gearshape")
                            })
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationBarTitle("App Menu")
                
                ItemsView()
                EmptyView()
//                DetailView(animal: "default")
                
            }
        }
}

struct SideBarAppView: View {
    var body: some View {
//        NavigationView {
//            Text("Something")
//            Text("Something")
//            Text("Something")
//        }
        
//        NavigationView {
//            List {
//                ForEach(0..<3, id: \.self) { number in
//                    NavigationLink {
//                        List {
//                            ForEach(4..<7, id: \.self) { subNumber in
//                                NavigationLink {
//                                    Text("\(number) : \(subNumber)")
//                                        .navigationTitle("Third")
//                                } label: {
//                                    Text("Navigate to \(number) : \(subNumber)")
//                                }
//                            }
//                        }
//                        .navigationTitle("Second")
//                    } label: {
//                        Text("\(number)")
//                    }
//                }
//            }
//            .navigationTitle("First")
//        }
        Something()
    }
}

struct ItemsView: View{
    let animals = ["Dog", "Cat", "Lion", "Squirrel"]
    var body: some View{
        List{
            ForEach(animals, id: \.self){ animal in
                NavigationLink(
                    destination: DetailView(animal: animal)){
                    Text(animal)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Animals")
    }
}

struct DetailView: View{
    var animal: String
    var body: some View{
        VStack{
            Text("🐕")
                .font(.title)
                .padding()
            Text(animal)
        }
    }
}

struct SideBarAppView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarAppView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
