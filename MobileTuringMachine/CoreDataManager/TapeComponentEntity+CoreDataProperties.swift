//
//  TapeComponentEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 24.06.2022.
//
//

import Foundation
import CoreData


extension TapeComponentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TapeComponentEntity> {
        return NSFetchRequest<TapeComponentEntity>(entityName: "TapeComponentEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var value: String?
    
    public var wrappedID: Int {
        Int(id)
    }
    
    public var wrappedValue: String {
        value ?? "_"
    }
    
    var tapeComponentStruct: TapeComponent {
        get {
            return TapeComponent(id: wrappedID, value: wrappedValue)
        }
        set {
            id = Int16(newValue.id)
            value = newValue.value
        }
    }

}

extension TapeComponentEntity : Identifiable {

}
