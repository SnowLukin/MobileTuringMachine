//
//  Algorithm+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 27.06.2022.
//
//

import Foundation
import CoreData


extension Algorithm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Algorithm> {
        return NSFetchRequest<Algorithm>(entityName: "Algorithm")
    }

    @NSManaged public var algorithmDescription: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var states: NSSet
    @NSManaged public var tapes: NSSet

    public var wrappedTapes: [Tape] {
        let set = tapes as? Set<Tape> ?? []
        return set.sorted {
            $0.nameID < $1.nameID
        }
    }
    public var wrappedStates: [StateQ] {
        let set = states as? Set<StateQ> ?? []
        return set.sorted {
            $0.nameID < $1.nameID
        }
    }
    
    func initValues(id: UUID = UUID(), name: String = "New Algorithm", description: String = "", states: [StateQ], tapes: [Tape]) {
        self.id = id
        self.name = name
        self.algorithmDescription = description
        self.states = NSSet(array: states)
        self.tapes = NSSet(array: tapes)
    }
}

// MARK: Generated accessors for states
extension Algorithm {

    @objc(addStatesObject:)
    @NSManaged public func addToStates(_ value: StateQ)

    @objc(removeStatesObject:)
    @NSManaged public func removeFromStates(_ value: StateQ)

    @objc(addStates:)
    @NSManaged public func addToStates(_ values: NSSet)

    @objc(removeStates:)
    @NSManaged public func removeFromStates(_ values: NSSet)

}

// MARK: Generated accessors for tapes
extension Algorithm {

    @objc(addTapesObject:)
    @NSManaged public func addToTapes(_ value: Tape)

    @objc(removeTapesObject:)
    @NSManaged public func removeFromTapes(_ value: Tape)

    @objc(addTapes:)
    @NSManaged public func addToTapes(_ values: NSSet)

    @objc(removeTapes:)
    @NSManaged public func removeFromTapes(_ values: NSSet)

}

extension Algorithm : Identifiable {

}
