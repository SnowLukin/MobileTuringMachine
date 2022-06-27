//
//  Option+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 27.06.2022.
//
//

import Foundation
import CoreData


extension Option {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Option> {
        return NSFetchRequest<Option>(entityName: "Option")
    }

    @NSManaged public var id: Int16
    @NSManaged public var toStateID: UUID
    @NSManaged public var combinations: NSSet
    @NSManaged public var state: StateQ

    public var wrappedCombinations: [Combination] {
        let set = combinations as? Set<Combination> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    func initValues(id: Int, toStateID: UUID, combinations: [Combination], state: StateQ) {
        self.id = Int16(id)
        self.toStateID = toStateID
        self.combinations = NSSet(array: combinations)
        self.state = state
    }
}

// MARK: Generated accessors for combinations
extension Option {

    @objc(addCombinationsObject:)
    @NSManaged public func addToCombinations(_ value: Combination)

    @objc(removeCombinationsObject:)
    @NSManaged public func removeFromCombinations(_ value: Combination)

    @objc(addCombinations:)
    @NSManaged public func addToCombinations(_ values: NSSet)

    @objc(removeCombinations:)
    @NSManaged public func removeFromCombinations(_ values: NSSet)

}

extension Option : Identifiable {

}
