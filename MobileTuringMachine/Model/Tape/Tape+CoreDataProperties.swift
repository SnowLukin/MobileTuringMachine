//
//  Tape+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 29.06.2022.
//
//

import Foundation
import CoreData


extension Tape {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tape> {
        return NSFetchRequest<Tape>(entityName: "Tape")
    }

    @NSManaged public var alphabet: String
    @NSManaged public var headIndex: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var input: String
    @NSManaged public var nameID: Int16
    @NSManaged public var algorithm: Algorithm
    @NSManaged public var components: NSSet

    public var wrappedComponents: [TapeComponent] {
        let set = components as? Set<TapeComponent> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    public var alphabetArray: [String] {
        var alphabetArray = alphabet.map { String($0) }
        alphabetArray.append("_")
        return alphabetArray
    }
    
    func initValues(id: UUID = UUID(), nameID: Int, alphabet: String = "", input: String = "",
                    headIndex: Int = 0, components: [TapeComponent], algorithm: Algorithm) {
        self.id = id
        self.nameID = Int16(nameID)
        self.alphabet = alphabet
        self.input = input
        self.headIndex = Int16(headIndex)
        self.components = NSSet(array: components)
        self.algorithm = algorithm
    }

}

// MARK: Generated accessors for components
extension Tape {

    @objc(addComponentsObject:)
    @NSManaged public func addToComponents(_ value: TapeComponent)

    @objc(removeComponentsObject:)
    @NSManaged public func removeFromComponents(_ value: TapeComponent)

    @objc(addComponents:)
    @NSManaged public func addToComponents(_ values: NSSet)

    @objc(removeComponents:)
    @NSManaged public func removeFromComponents(_ values: NSSet)

}

extension Tape : Identifiable {

}
