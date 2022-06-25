//
//  Combination.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//

import Foundation

struct Combination: Identifiable, Codable {
    var id: Int
    var character: String
    var direction: Direction
    var toCharacter: String
}
