//
//  Tape.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

struct Tape: Identifiable {
    
    var id: Int
    var alphabet: String = "abs"
    var input: String = "abs"
    var headIndex = 0
    
    var alphabetArray: [String] {
        var result = alphabet.map { String($0) }
        result.append("_")
        return result
    }
}

struct Exit: Identifiable {
    enum Side {
        case stay
        case left
        case right
    }
    
    var id: Int
    var expectedLetters = "_"
    var toLetters = ["_", "_", "_", "_", "_"]
    
    var moving: [Side] = [.stay, .stay, .stay, .stay, .stay]
}
