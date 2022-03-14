//
//  Tape.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

struct Tape: Identifiable, Equatable {
    
    var id: Int
    var alphabet: String = ""
    var input: String = ""
    
}
