//
//  AlgorithmEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//
//

import Foundation
import CoreData


extension AlgorithmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlgorithmEntity> {
        return NSFetchRequest<AlgorithmEntity>(entityName: "AlgorithmEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var alDescription: String?
    @NSManaged public var tapes: NSSet?
    @NSManaged public var states: NSSet?
    @NSManaged public var stateForReset: StateQEntity!
    
    public var wrappedID: UUID {
        id ?? UUID()
    }
    public var wrappedName: String {
        name ?? "New Algorithm"
    }
    public var wrappedAlDescription: String {
        alDescription ?? ""
    }
    public var wrappedTapes: [TapeEntity] {
        let set = tapes as? Set<TapeEntity> ?? []
        return set.sorted {
            $0.wrappedNameID < $1.wrappedNameID
        }
    }
    public var wrappedStates: [StateQEntity] {
        let set = states as? Set<StateQEntity> ?? []
        return set.sorted {
            $0.wrappedNameID < $1.wrappedNameID
        }
    }
    
    var stateQStruct: [StateQ] {
        get {
            
        }
        set {
            
        }
    }
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

extension AlgorithmEntity : Identifiable {

}
