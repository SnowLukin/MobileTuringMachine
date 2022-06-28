//
//  AlgorithmEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 28.06.2022.
//
//

import Foundation
import CoreData


extension AlgorithmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlgorithmEntity> {
        return NSFetchRequest<AlgorithmEntity>(entityName: "AlgorithmEntity")
    }

    @NSManaged public var algorithmDescription: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var stateForReset: StateQEntity
    @NSManaged public var states: NSSet
    @NSManaged public var tapes: NSSet

    public var wrappedTapes: [TapeEntity] {
        let set = tapes as? Set<TapeEntity> ?? []
        return set.sorted {
            $0.nameID < $1.nameID
        }
    }
    public var wrappedStates: [StateQEntity] {
        let set = states as? Set<StateQEntity> ?? []
        return set.sorted {
            $0.nameID < $1.nameID
        }
    }
    
    var algorithmModel: Algorithm {
        get {
            Algorithm(
                id: id,
                name: name,
                description: algorithmDescription,
                tapes: wrappedTapes.map { $0.tapeModel },
                states: wrappedStates.map { $0.stateQModel },
                stateForReset: stateForReset.stateQModel
            )
        }
        set {
            id = newValue.id
            name = newValue.name
            algorithmDescription = newValue.description
            
            let newStateForReset = StateQEntity(context: DataManager.shared.container.viewContext)
            newStateForReset.stateQModel = newValue.stateForReset
            stateForReset = newStateForReset
            
            tapes = []
            for tape in newValue.tapes {
                let newTape = TapeEntity(context: DataManager.shared.container.viewContext)
                newTape.tapeModel = tape
                addToTapes(newTape)
            }
            
            states = []
            for state in newValue.states {
                let newState = StateQEntity(context: DataManager.shared.container.viewContext)
                newState.stateQModel = state
                addToStates(newState)
            }
        }
    }
}

// MARK: Generated accessors for states
extension AlgorithmEntity {

    @objc(addStatesObject:)
    @NSManaged public func addToStates(_ value: StateQEntity)

    @objc(removeStatesObject:)
    @NSManaged public func removeFromStates(_ value: StateQEntity)

    @objc(addStates:)
    @NSManaged public func addToStates(_ values: NSSet)

    @objc(removeStates:)
    @NSManaged public func removeFromStates(_ values: NSSet)

}

// MARK: Generated accessors for tapes
extension AlgorithmEntity {

    @objc(addTapesObject:)
    @NSManaged public func addToTapes(_ value: TapeEntity)

    @objc(removeTapesObject:)
    @NSManaged public func removeFromTapes(_ value: TapeEntity)

    @objc(addTapes:)
    @NSManaged public func addToTapes(_ values: NSSet)

    @objc(removeTapes:)
    @NSManaged public func removeFromTapes(_ values: NSSet)

}

extension AlgorithmEntity : Identifiable {

}
