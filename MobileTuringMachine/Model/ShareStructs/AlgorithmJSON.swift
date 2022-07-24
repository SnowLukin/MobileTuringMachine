//
//  AlgorithmJSON.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.07.2022.
//

import Foundation

struct AlgorithmJSON: Codable {
    let name: String
    let algorithmDescription: String
    let states: [StateQJSON]
    let tapes: [TapeJSON]
}
