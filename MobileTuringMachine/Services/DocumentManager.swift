//
//  DocumentManager.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentManager: FileDocument {
    
    static var readableContentTypes: [UTType] { [ .mtm ] }
    
    var algorithm: AlgorithmJSON
    
    init(algorithm: AlgorithmJSON) {
        self.algorithm = algorithm
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let dataAlgorithm = try? JSONDecoder().decode(AlgorithmJSON.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        algorithm = dataAlgorithm
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encodedData = try JSONEncoder().encode(algorithm)
        let fileWrapper = FileWrapper(regularFileWithContents: encodedData)
        return fileWrapper
    }
}
