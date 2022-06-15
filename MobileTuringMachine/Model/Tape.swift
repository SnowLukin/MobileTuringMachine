//
//  Tape.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

struct Tape: Identifiable {
    
    let id = UUID()
    var nameID: Int
    var alphabet: String = ""
    var input: String = ""
    var headIndex = 0
    var components: [TapeContent]
//    var components: [(id: Int, value: String)]
    
    var alphabetArray: [String] {
        var result = alphabet.map { String($0) }
        result.append("_")
        return result
    }
}
