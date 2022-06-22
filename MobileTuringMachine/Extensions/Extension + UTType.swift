//
//  Extension + UTType.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    static var mtm: UTType {
        UTType(importedAs: "com.SnowLukin.TuringMachine.TuringMachineData")
    }
}
