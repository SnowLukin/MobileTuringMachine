//
//  DataManager.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 19.06.2022.
//

import Foundation


class DataManager {
    
    static let shared = DataManager()
    
    let algorithmsKey: String = "algorithms_data_key"
    
    private let userDefaults = UserDefaults()
    
    func updateStorage(with algorithms: [Algorithm], for key: String = "algorithms_data_key") {
        if let encodedData = try? JSONEncoder().encode(algorithms) {
            userDefaults.set(encodedData, forKey: key)
        }
    }
    
    func getStorage(for key: String = "algorithms_data_key") -> [Algorithm]? {
        guard let data = userDefaults.data(forKey: key),
              let savedData = try? JSONDecoder().decode([Algorithm].self, from: data) else {
            print("No saved data found.")
            print("DataManager line 23")
            return nil
        }
        return savedData
    }
}
