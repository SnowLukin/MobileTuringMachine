//
//  StateQ+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 27.06.2022.
//
//

import Foundation
import CoreData


extension StateQ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StateQ> {
        return NSFetchRequest<StateQ>(entityName: "StateQ")
    }

    @NSManaged public var id: UUID
    @NSManaged public var isStarting: Bool
    @NSManaged public var nameID: Int16
    @NSManaged public var isForReset: Bool
    @NSManaged public var options: NSSet
    @NSManaged public var algorithm: Algorithm

    public var wrappedOptions: [Option] {
        let set = options as? Set<Option> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    func initValues(id: UUID = UUID(), nameID: Int, isStarting: Bool = false,
                    isForReset: Bool = false, options: [Option], algorithm: Algorithm) {
        self.id = id
        self.nameID = Int16(nameID)
        self.isStarting = isStarting
        self.isForReset = isForReset
        self.options = NSSet(array: options)
        self.algorithm = algorithm
    }
}

// MARK: Generated accessors for options
extension StateQ {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: Option)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: Option)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}

extension StateQ : Identifiable {

}
