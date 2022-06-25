//
//  OptionState.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 18.03.2022.
//

import Foundation

struct Option: Identifiable, Codable {
    var id: Int
    var toState: StateQ
    var combinations: [Combination]
}
