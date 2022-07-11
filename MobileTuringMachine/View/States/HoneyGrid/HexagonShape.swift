//
//  Hexagon.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 16.06.2022.
//

import SwiftUI

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
            return Path { path in
                let point1 = CGPoint(x: 0, y: 20)
                let point2 = CGPoint(x: 0, y: rect.height - 20)
                let point3 = CGPoint(x: rect.width / 2, y: rect.height)
                let point4 = CGPoint(x: rect.width, y: rect.height - 20)
                let point5 = CGPoint(x: rect.width, y: 20)
                let point6 = CGPoint(x: rect.width / 2, y: 0)
                
                path.move(to: point6)
                
                path.addArc(tangent1End: point1, tangent2End: point2, radius: 15)
                path.addArc(tangent1End: point2, tangent2End: point3, radius: 15)
                path.addArc(tangent1End: point3, tangent2End: point4, radius: 15)
                path.addArc(tangent1End: point4, tangent2End: point5, radius: 15)
                path.addArc(tangent1End: point5, tangent2End: point6, radius: 15)
                path.addArc(tangent1End: point6, tangent2End: point1, radius: 15)
            }
        }
}

struct Test: View {
    let size: CGFloat = 110
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Hexagon()
                    .frame(width: size, height: size, alignment: .center)
                Hexagon()
                    .frame(width: size, height: size, alignment: .center)
                Hexagon()
                    .frame(width: size, height: size, alignment: .center)
            }
            HStack {
                Hexagon()
                    .frame(width: size, height: size, alignment: .center)
                Hexagon()
                    .frame(width: size, height: size, alignment: .center)
            }
        }
    }
}

struct Hexagon_Previews: PreviewProvider {
    static var previews: some View {
//        Hexagon()
//            .frame(width: 100, height: 100, alignment: .center)
//            .padding()
        Test()
    }
}
