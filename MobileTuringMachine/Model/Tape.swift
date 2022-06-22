//
//  Tape.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

struct Tape: Identifiable, Equatable, Hashable, Codable {
    
    static func == (lhs: Tape, rhs: Tape) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    var nameID: Int
    var alphabet: String = ""
    var input: String = ""
    var headIndex = 0
    var components: [TapeComponent]
    
    var alphabetArray: [String] {
        var result = alphabet.map { String($0) }
        result.append("_")
        return result
    }
}
