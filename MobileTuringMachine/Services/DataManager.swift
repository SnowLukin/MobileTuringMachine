//
//  DataManager.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 19.06.2022.
//

import Foundation


class DataManager {
    
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults()
    
    func updateStorage(with tapes: [Tape], for key: String) {
        if let encodedData = try? JSONEncoder().encode(tapes) {
            userDefaults.set(encodedData, forKey: key)
        }
    }
    
    func getStorage(for key: String) -> [Tape]? {
        guard let data = userDefaults.data(forKey: key),
              let savedTapes = try? JSONDecoder().decode([Tape].self, from: data) else {
            print("Error occupied. Failed decoding data.")
            print("DataManager line 23")
            return nil
        }
        return savedTapes
    }
}
