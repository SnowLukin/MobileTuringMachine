//
//  TapeContent.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

struct TapeComponent: Identifiable, Hashable, Codable {
    let id: Int
    var value = "_"
}
