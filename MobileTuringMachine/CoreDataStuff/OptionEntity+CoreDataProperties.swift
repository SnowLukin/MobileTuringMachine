//
//  OptionEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 25.06.2022.
//
//

import Foundation
import CoreData


extension OptionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OptionEntity> {
        return NSFetchRequest<OptionEntity>(entityName: "OptionEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var combinations: NSSet
    @NSManaged public var toState: StateQEntity
    @NSManaged public var state: StateQEntity?
    
    
    
    public var wrappedCombinations: [CombinationEntity] {
        let set = combinations as? Set<CombinationEntity> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    var optionModel: Option {
        get {
            Option(
                id: Int(id),
                toState: toState.stateQModel,
                combinations: wrappedCombinations.map { $0.combinationModel }
            )
        }
        set {
            id = Int16(newValue.id)
            toState.stateQModel = newValue.toState
            
            combinations = []
            for combination in newValue.combinations {
                let newCombination = CombinationEntity()
                newCombination.combinationModel = combination
                combinations.adding(newCombination)
            }
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
