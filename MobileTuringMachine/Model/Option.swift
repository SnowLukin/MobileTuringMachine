//
//  OptionState.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 18.03.2022.
//

import Foundation

enum Direction: String, CaseIterable, Codable {
    case stay = "arrow.counterclockwise"
    case left = "arrow.left"
    case right = "arrow.right"
}

struct Option: Identifiable, Codable {
    var id = UUID()
    var toState: StateQ
    var combinations: [Combination]
}

struct Combination: Identifiable, Codable {
    var id = UUID()
    var character: String
    var direction: Direction
    var toCharacter: String
}
