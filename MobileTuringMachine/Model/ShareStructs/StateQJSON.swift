//
//  StateQJSON.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.07.2022.
//

import Foundation

struct StateQJSON: Codable {
    let id: UUID
    let nameID: Int16
    let isForReset: Bool
    let isStarting: Bool
    let options: [OptionJSON]
}
