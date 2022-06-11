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

struct OptionState: Identifiable {
    let id: Int
    var toStateID: Int
    var combinationsTuple: [(character: String, direction: Direction, toCharacter: String)]
}
