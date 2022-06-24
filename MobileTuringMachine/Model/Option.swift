//
//  OptionState.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 18.03.2022.
//

import Foundation

struct Option: Identifiable, Codable {
    var id = UUID()
    var toState: StateQ
    var combinations: [Combination]
}
