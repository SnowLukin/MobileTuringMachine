//
//  Algorithm+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 01.07.2022.
//
//

import Foundation
import CoreData


extension Algorithm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Algorithm> {
        return NSFetchRequest<Algorithm>(entityName: "Algorithm")
    }

    @NSManaged public var algorithmDescription: String
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var editedDate: Date?
    @NSManaged public var creationDate: Date?
    @NSManaged public var pinned: Bool
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
    
    public var wrappedCreationDate: Date {
        handleCreationDate()
    }
    
    public var wrappedEditedDate: Date {
        handleEditedDate()
    }
    
    func initValues(id: UUID = UUID(), name: String = "New Algorithm",
                    algorithmDescription: String = "", states: [StateQ],
                    pinned: Bool = false, tapes: [Tape],
                    creationDate: Date = Date.now) {
        self.id = id
        self.name = name
        self.algorithmDescription = algorithmDescription
        self.states = NSSet(array: states)
        self.pinned = pinned
        self.tapes = NSSet(array: tapes)
        self.creationDate = creationDate
        self.editedDate = creationDate
    }
    
    private func handleCreationDate() -> Date {
        if let creationDate = creationDate {
            return creationDate
        }
        creationDate = Date.now
        return creationDate!
    }
    
    private func handleEditedDate() -> Date {
        if let editedDate = editedDate {
            return editedDate
        }
        editedDate = Date.now
        return editedDate!
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
