//
//  OptionEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//
//

import Foundation
import CoreData


extension OptionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OptionEntity> {
        return NSFetchRequest<OptionEntity>(entityName: "OptionEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nameID: Int16
    @NSManaged public var combinations: NSSet?
    @NSManaged public var toState: StateQEntity!

    public var wrappedID: UUID {
        id ?? UUID()
    }
    
    public var wrappedCombinations: [CombinationEntity] {
        let set = combinations as? Set<CombinationEntity> ?? []
        return set.sorted {
            $0.wrappedID < $1.wrappedID
        }
    }
        
}

// MARK: Generated accessors for combinations
extension OptionEntity {

    @objc(addCombinationsObject:)
    @NSManaged public func addToCombinations(_ value: CombinationEntity)

    @objc(removeCombinationsObject:)
    @NSManaged public func removeFromCombinations(_ value: CombinationEntity)

    @objc(addCombinations:)
    @NSManaged public func addToCombinations(_ values: NSSet)

    @objc(removeCombinations:)
    @NSManaged public func removeFromCombinations(_ values: NSSet)

}

extension OptionEntity : Identifiable {

}
