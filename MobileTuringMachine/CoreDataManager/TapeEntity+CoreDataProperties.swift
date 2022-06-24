//
//  TapeEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//
//

import Foundation
import CoreData


extension TapeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TapeEntity> {
        return NSFetchRequest<TapeEntity>(entityName: "TapeEntity")
    }

    @NSManaged public var headIndex: Int16
    @NSManaged public var input: String?
    @NSManaged public var alphabet: String?
    @NSManaged public var nameID: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var components: NSSet?

    public var wrappedHeadIndex: Int {
        Int(headIndex)
    }
    
    public var wrappedInput: String {
        input ?? ""
    }
    
    public var wrappedAlphabet: String {
        alphabet ?? ""
    }
    
    public var wrappedNameID: Int {
        Int(nameID)
    }
    
    public var wrappedID: UUID {
        id ?? UUID()
    }
    
    public var wrappedComponents: [TapeComponentEntity] {
        let set = components as? Set<TapeComponentEntity> ?? []
        return set.sorted {
            $0.wrappedID < $1.wrappedID
        }
    }
}

// MARK: Generated accessors for components
extension TapeEntity {

    @objc(addComponentsObject:)
    @NSManaged public func addToComponents(_ value: TapeComponentEntity)

    @objc(removeComponentsObject:)
    @NSManaged public func removeFromComponents(_ value: TapeComponentEntity)

    @objc(addComponents:)
    @NSManaged public func addToComponents(_ values: NSSet)

    @objc(removeComponents:)
    @NSManaged public func removeFromComponents(_ values: NSSet)

}

extension TapeEntity : Identifiable {

}
