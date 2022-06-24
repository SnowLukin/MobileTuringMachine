//
//  AlgorithmsEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//
//

import Foundation
import CoreData


extension AlgorithmsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlgorithmsEntity> {
        return NSFetchRequest<AlgorithmsEntity>(entityName: "AlgorithmsEntity")
    }

    @NSManaged public var algorithms: NSSet?

}

// MARK: Generated accessors for algorithms
extension AlgorithmsEntity {

    @objc(addAlgorithmsObject:)
    @NSManaged public func addToAlgorithms(_ value: AlgorithmEntity)

    @objc(removeAlgorithmsObject:)
    @NSManaged public func removeFromAlgorithms(_ value: AlgorithmEntity)

    @objc(addAlgorithms:)
    @NSManaged public func addToAlgorithms(_ values: NSSet)

    @objc(removeAlgorithms:)
    @NSManaged public func removeFromAlgorithms(_ values: NSSet)

}

extension AlgorithmsEntity : Identifiable {

}
