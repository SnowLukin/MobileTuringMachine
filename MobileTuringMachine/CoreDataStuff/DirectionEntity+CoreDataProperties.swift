//
//  DirectionEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 25.06.2022.
//
//

import Foundation
import CoreData


extension DirectionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DirectionEntity> {
        return NSFetchRequest<DirectionEntity>(entityName: "DirectionEntity")
    }

    @NSManaged public var state: Int16
    @NSManaged public var combination: CombinationEntity?

    var directionModel: Direction {
        get {
            switch state {
            case 1:
                return .left
            case 2:
                return .right
            default:
                return .stay
            }
        }
        set {
            switch newValue {
            case Direction.stay:
                state = 0
            case Direction.left:
                state = 1
            default:
                state = 2
            }
        }
    }
}

extension DirectionEntity : Identifiable {

}
