//
//  TapeJSON.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.07.2022.
//

import Foundation

struct TapeJSON: Codable {
    let nameID: Int16
    let headIndex: Int16
    let alphabet: String
    let input: String
}
