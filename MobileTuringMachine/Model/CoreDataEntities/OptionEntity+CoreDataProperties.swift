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
            let newToStateEntity = StateQEntity(context: DataManager.shared.container.viewContext)
            newToStateEntity.id = newValue.toState.id
            newToStateEntity.nameID = Int16(newValue.toState.nameID)
            newToStateEntity.isStarting = newValue.toState.isStarting
            newToStateEntity.options = []
            toState = newToStateEntity
            
            combinations = []
            for combination in newValue.combinations {
                let newCombination = CombinationEntity(context: DataManager.shared.container.viewContext)
                newCombination.combinationModel = combination
                addToCombinations(newCombination)
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
