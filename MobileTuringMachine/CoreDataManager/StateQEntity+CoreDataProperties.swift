//
//  StateQEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//
//

import Foundation
import CoreData


extension StateQEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StateQEntity> {
        return NSFetchRequest<StateQEntity>(entityName: "StateQEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nameID: Int16
    @NSManaged public var isStarting: Bool
    @NSManaged public var options: NSSet?
    
    public var wrappedID: UUID {
        id ?? UUID()
    }
    
    public var wrappedNameID: Int {
        Int(nameID)
    }
    
    public var wrappedOptions: [OptionEntity] {
        let set = options as? Set<OptionEntity> ?? []
        return set.sorted {
            $0.
        }
    }
    
}

// MARK: Generated accessors for options
extension StateQEntity {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: OptionEntity)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: OptionEntity)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}

extension StateQEntity : Identifiable {

}
