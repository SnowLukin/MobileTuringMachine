//
//  RoundedCornersBackground.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

struct RoundedCornersBackground: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
