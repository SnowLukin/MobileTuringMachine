//
//  TapeComponent+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 27.06.2022.
//
//

import Foundation
import CoreData


extension TapeComponent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TapeComponent> {
        return NSFetchRequest<TapeComponent>(entityName: "TapeComponent")
    }

    @NSManaged public var id: Int16
    @NSManaged public var value: String
    @NSManaged public var tape: Tape

    func initValues(id: Int, value: String = "_", tape: Tape) {
        self.id = Int16(id)
        self.value = value
        self.tape = tape
    }
}

extension TapeComponent : Identifiable {

}
