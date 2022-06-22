//
//  Extension + FileManager.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import Foundation

extension FileManager {
    static var documentsDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
