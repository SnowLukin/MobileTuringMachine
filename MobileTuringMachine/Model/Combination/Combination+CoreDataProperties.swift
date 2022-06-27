//
//  Combination+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 27.06.2022.
//
//

import Foundation
import CoreData


extension Combination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Combination> {
        return NSFetchRequest<Combination>(entityName: "Combination")
    }

    @NSManaged public var character: String
    @NSManaged public var id: Int16
    @NSManaged public var toCharacter: String
    @NSManaged public var directionID: Int16
    @NSManaged public var option: Option
    
    var directionImageValue: String {
        switch directionID {
        case 0:
            return "arrow.counterclockwise"
        case 1:
            return "arrow.left"
        default:
            return "arrow.right"
        }
    }

    func initValues(id: Int, character: String, directionID: Int, option: Option) {
        self.id = Int16(id)
        self.character = character
        self.directionID = Int16(directionID)
        self.toCharacter = character
        self.option = option
    }
}

extension Combination : Identifiable {

}
