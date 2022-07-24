//
//  OptionJSON.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.07.2022.
//

import Foundation

struct OptionJSON: Codable {
    let id: Int16
    let toStateID: UUID
    let combinations: [CombinationJSON]
}
