//
//  StateQEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 25.06.2022.
//
//

import Foundation
import CoreData


extension StateQEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StateQEntity> {
        return NSFetchRequest<StateQEntity>(entityName: "StateQEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var nameID: Int16
    @NSManaged public var isStarting: Bool
    @NSManaged public var options: NSSet
    @NSManaged public var algorithm: AlgorithmEntity?
    @NSManaged public var algorithmReset: AlgorithmEntity?
    @NSManaged public var optionToState: OptionEntity?

    public var wrappedOptions: [OptionEntity] {
        let set = options as? Set<OptionEntity> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    var stateQModel: StateQ {
        get {
            StateQ(
                nameID: Int(nameID),
                options: wrappedOptions.map { $0.optionModel },
                isStarting: isStarting
            )
        }
        set {
            id = newValue.id
            nameID = Int16(newValue.nameID)
            isStarting = newValue.isStarting
            
            options = []
            for option in newValue.options {
                let newOption = OptionEntity()
                newOption.optionModel = option
                options.adding(newOption)
            }
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
