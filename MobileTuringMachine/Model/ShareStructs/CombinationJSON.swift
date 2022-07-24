//
//  CombinationJSON.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.07.2022.
//

import Foundation

struct CombinationJSON: Codable {
    let id: Int16
    let character: String
    let directionID: Int16
    let toCharacter: String
}
