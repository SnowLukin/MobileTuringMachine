//
//  Exit.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 25.04.2022.
//

import Foundation


struct Exit: Identifiable {
    enum Side {
        case stay
        case left
        case right
    }
    
    var id: Int
    var expectedLetters = "_"
    var toLetters = ["aa", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab", "ab" ]
    var moving: [Side] = [.stay, .stay, .stay, .stay, .stay]
}
