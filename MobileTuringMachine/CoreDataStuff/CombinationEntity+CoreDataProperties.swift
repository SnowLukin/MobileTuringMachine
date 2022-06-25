//
//  CombinationEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 25.06.2022.
//
//

import Foundation
import CoreData


extension CombinationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CombinationEntity> {
        return NSFetchRequest<CombinationEntity>(entityName: "CombinationEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var character: String
    @NSManaged public var toCharacter: String
    @NSManaged public var direction: DirectionEntity
    @NSManaged public var option: OptionEntity?

    
    var combinationModel: Combination {
        get {
            Combination(
                id: Int(id),
                character: character,
                direction: direction.directionModel,
                toCharacter: toCharacter
            )
        }
        set {
            id = Int16(newValue.id)
            character = newValue.character
            toCharacter = newValue.toCharacter
            direction.directionModel = newValue.direction
        }
    }
}

extension CombinationEntity : Identifiable {

}
