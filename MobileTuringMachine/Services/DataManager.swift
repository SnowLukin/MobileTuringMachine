//
//  DataManager.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    let container: NSPersistentContainer
    private let containerName: String = "AlgorithmsData"
    private let entityName: String = "Folder"
    
    @Published var savedFolders: [Folder] = []
    
    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading CoreData. \(error.localizedDescription)")
            }
        }
    }
    
    func isEmpty() -> Bool {
        do {
            let request = NSFetchRequest<Folder>(entityName: entityName)
            let count = try container.viewContext.count(for: request)
            if count == 0 {
                return true
            }
            return false
        } catch {
            print("Failed to check core data.")
            print(error.localizedDescription)
            return true
        }
    }
    
    func applyChanges() {
        save()
        getFolders()
    }
    
    func getFolders() {
        let request = NSFetchRequest<Folder>(entityName: entityName)
//        request.returnsObjectsAsFaults = false
        do {
            savedFolders = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching Favorities Entities. \(error)")
        }
    }
    
    private func save() {
        do {
            try container.viewContext.save()
            print("Changes saved")
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
}
