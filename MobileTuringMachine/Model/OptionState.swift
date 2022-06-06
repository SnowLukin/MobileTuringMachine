//
//  OptionState.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 18.03.2022.
//

import Foundation

struct StateQ: Identifiable {
    let id: Int
    var options: [OptionState]
}

enum Direction: String {
    case stay = "arrow.counterclockwise"
    case left = "arrow.left"
    case right = "arrow.right"
}

struct OptionState: Identifiable {
    
    let id: Int
    var combinations: [String]
    var toCombination: [String]
    var toStateID: Int
    
    var combinationsTuple: [(character: String, direction: Direction, toCharacter: String)]
    // MARK: Array of combinations as Element of the tape and  its direction
//    var combinationsTuple: [(character: String, direction: Direction)] {
//        var combinationsTuple: [(character: String, direction: Direction)] = []
//        for combination in combinations {
//            combinationsTuple.append((combination, .stay))
//        }
//        return combinationsTuple
//    }
    
    init(id: Int, combinations: [String], toStateID: Int, combinationTuple: [(character: String, direction: Direction, toCharacter: String)]) {
        self.id = id
        self.combinations = combinations
        toCombination = combinations
        self.toStateID = toStateID
        self.combinationsTuple = combinationTuple
    }
}
