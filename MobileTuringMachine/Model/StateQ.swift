//
//  StateQ.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import Foundation

struct StateQ: Identifiable, Equatable {
    static func == (lhs: StateQ, rhs: StateQ) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    var nameID: Int
    var options: [OptionState]
}
