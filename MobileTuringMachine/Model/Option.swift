//
//  OptionState.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 18.03.2022.
//

import Foundation

enum Direction: String, CaseIterable {
    case stay = "arrow.counterclockwise"
    case left = "arrow.left"
    case right = "arrow.right"
}

struct Option: Identifiable {
    let id = UUID()
    var toState: StateQ
    var combinations: [Combination]
}

struct Combination: Identifiable {
    let id = UUID()
    var character: String
    var direction: Direction
    var toCharacter: String
}
