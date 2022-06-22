//
//  Algorithm.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 19.06.2022.
//

import Foundation

struct Algorithm: Identifiable, Codable {
    
    var id = UUID()
    var name: String
    var tapes: [Tape]
    var states: [StateQ]
    var stateForReset: StateQ
    
}
