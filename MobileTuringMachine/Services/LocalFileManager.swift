//
//  LocalFileManager.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 22.06.2022.
//

import Foundation

class LocalFileManager {
    static let shared = LocalFileManager()
    
    func saveData(algorithms: [Algorithm], name: String = "algorithms") {
        
        do {
            print(1)
            guard let path = getPathForData() else { return }
            print(2)
            let encodedData = try PropertyListEncoder().encode(algorithms)
            print(encodedData)
            print(3)
            try encodedData.write(to: path)
            print(4)
            print("Data successfuly written to path")
        } catch {
            print("Error occipied.")
            print(error.localizedDescription)
        }
    }
    
    func getData() -> [Algorithm]? {
        guard
            let path = getPathForData(),
            FileManager.default.fileExists(atPath: path.path) else {
            print("Failed to find the path.")
            return nil
        }
        guard let data = try? Data(contentsOf: path) else {
            print("Failed getting data from url: \(path)")
            return nil
        }
        guard let algorithms = try? PropertyListDecoder().decode([Algorithm].self, from: data) else {
            print("Failed decoding file.")
            return nil
        }
        print(algorithms.count)
        print(algorithms.map { $0.tapes.count } )
        print(algorithms.map { $0.states.count } )
        return algorithms
    }
    
    func getPathForData(name: String = "algorithms") -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(name).json") else {
            print("Failed to get path to the directory.")
            return nil
        }
        print(path)
        return path
    }
    
}
