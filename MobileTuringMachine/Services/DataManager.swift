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
    private let entityName: String = "AlgorithmEntity"
    
    @Published var savedEntities: [AlgorithmEntity] = []
    
    var savedAlgorithms: [Algorithm] {
        savedEntities.map { $0.algorithmModel }
    }
    
    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading CoreData. \(error.localizedDescription)")
            }
            self.getAlgorithms()
        }
    }
    
    func isEmpty() -> Bool {
        do {
            let request = NSFetchRequest<AlgorithmEntity>(entityName: entityName)
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
    
    func add(algorithm: Algorithm) {
        let entity = AlgorithmEntity(context: container.viewContext)
        entity.algorithmModel = algorithm
        applyChanges()
    }
    
    func delete(algorithm: Algorithm) {
        guard let entity = savedEntities.first(where: { $0.id == algorithm.id }) else { return }
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    func update(algorithm: Algorithm) {
        guard let entity = savedEntities.first(where: { $0.id == algorithm.id }) else {
            print("Error updating")
            return
        }
        container.viewContext.delete(entity)
        let newEntity = AlgorithmEntity(context: container.viewContext)
        newEntity.algorithmModel = algorithm
        applyChanges()
    }
    
    private func getAlgorithms() {
        let request = NSFetchRequest<AlgorithmEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
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
    
    private func applyChanges() {
        save()
        getAlgorithms()
    }
}
