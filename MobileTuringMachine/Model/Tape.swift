//
//  Tape.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

struct Tape: Identifiable {
    
    var id: Int
    var alphabet: String = "abc"
    var input: String = "abc"
    var headIndex = 0
    
    var alphabetArray: [String] {
        var result = alphabet.map { String($0) }
        result.append("_")
        return result
    }
}
