//
//  CombinationEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//
//

import Foundation
import CoreData


extension CombinationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CombinationEntity> {
        return NSFetchRequest<CombinationEntity>(entityName: "CombinationEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var character: String?
    @NSManaged public var toCharacter: String?
    @NSManaged public var direction: DirectionEntity!
    
    public var wrappedID: UUID {
        id ?? UUID()
    }
    
    public var wrapedCharacter: String {
        character ?? "_"
    }
    
    public var wrapedToCharacter: String {
        toCharacter ?? "_"
    }
    
    public var wrapedDirection: DirectionEntity {
        guard let wrappedDirection = direction else {
            let defaultDirection = DirectionEntity()
            defaultDirection.state = 0
            return defaultDirection
        }
        return wrappedDirection
    }
    
    var combinationStruct: Combination {
        get {
            Combination(
                id: wrappedID,
                character: wrapedCharacter,
                direction: wrapedDirection.directionValue,
                toCharacter: wrapedToCharacter
            )
        }
        set {
            id = newValue.id
            character = newValue.character
            toCharacter = newValue.toCharacter
            
            let newDirection = DirectionEntity()
            newDirection.state = newValue.direction.rawValue
            direction = newDirection
        }
    }

}

extension CombinationEntity : Identifiable {

}
