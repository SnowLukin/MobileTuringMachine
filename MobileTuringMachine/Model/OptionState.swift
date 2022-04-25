//
//  OptionState.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 18.03.2022.
//

import Foundation

struct OptionState: Hashable {
    
    enum Direction: String {
        case bottom = "Bottom"
        case left = "Left"
        case right = "Right"
    }
    
    let idInRow: Int
    
    let combination: String
    var direction: Direction
    let stateID: Int
    
    var toCombination: String
    var toStateID: Int
    
    init(idInRow: Int, combination: String, direction: Direction = .bottom, stateID: Int) {
        self.idInRow = idInRow
        self.stateID = stateID
        self.direction = direction
        self.combination = combination
        toCombination = combination
        toStateID = stateID
    }
}
