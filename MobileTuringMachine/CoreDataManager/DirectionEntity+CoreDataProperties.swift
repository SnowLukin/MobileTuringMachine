//
//  DirectionEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//
//

import Foundation
import CoreData


extension DirectionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DirectionEntity> {
        return NSFetchRequest<DirectionEntity>(entityName: "DirectionEntity")
    }

    @NSManaged public var state: Int16

    var directionValue: Direction {
        switch state {
        case 1:
            return Direction.left
        case 2:
            return Direction.right
        default:
            return Direciton.stay
        }
    }
}

extension DirectionEntity : Identifiable {

}
