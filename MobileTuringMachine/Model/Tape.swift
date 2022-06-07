//
//  Tape.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

struct Tape: Identifiable {
    
    var id: Int
    var alphabet: String = ""
    var input: String = ""
    var headIndex = 0
    var components: [TapeContent]
    
    var alphabetArray: [String] {
        var result = alphabet.map { String($0) }
        result.append("_")
        return result
    }
}
