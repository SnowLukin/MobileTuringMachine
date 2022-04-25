//
//  CustomGrid.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 14.03.2022.
//

import SwiftUI

struct CustomVerticalGrid<Content, T>: View where Content : View {
    let columns: Int
    let items: [T]
    let content: (CGFloat, T) -> Content
    
    var rows: Int {
        items.count / columns
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let size = geometry.size.width / CGFloat(columns)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0...rows, id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<columns) { columnIndex in
                                if let index = indexFor(row: rowIndex, column: columnIndex) {
                                    content(size, items[index])
                                } else {
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }.frame(width: geometry.size.width)
        }
    }
}

struct CustomGrid_Previews: PreviewProvider {
    static var previews: some View {
        CustomVerticalGrid(columns: 3, items: ["R", "R", "R", "R", "R", "R"]) { itemSize, item in
            Text("\(item)")
                .frame(width: itemSize, height: itemSize)
                .background(.red)
        }.padding()
    }
}

extension CustomVerticalGrid {
    
    private func indexFor(row: Int, column: Int) -> Int? {
        let index = row * columns + column
        return index < items.count ? index : nil
    }
    
}
