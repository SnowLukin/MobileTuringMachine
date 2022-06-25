//
//  TapeComponentEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 25.06.2022.
//
//

import Foundation
import CoreData


extension TapeComponentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TapeComponentEntity> {
        return NSFetchRequest<TapeComponentEntity>(entityName: "TapeComponentEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var value: String

    var componentModel: TapeComponent {
        get {
            TapeComponent(id: Int(id), value: value)
        }
        set {
            id = Int16(newValue.id)
            value = newValue.value
        }
    }
}

extension TapeComponentEntity : Identifiable {

}
