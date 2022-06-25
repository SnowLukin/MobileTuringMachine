//
//  TapeEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 25.06.2022.
//
//

import Foundation
import CoreData


extension TapeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TapeEntity> {
        return NSFetchRequest<TapeEntity>(entityName: "TapeEntity")
    }

    @NSManaged public var headIndex: Int16
    @NSManaged public var input: String
    @NSManaged public var alphabet: String
    @NSManaged public var nameID: Int16
    @NSManaged public var id: UUID
    @NSManaged public var components: NSSet

    public var wrappedComponents: [TapeComponentEntity] {
        let set = components as? Set<TapeComponentEntity> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
    var tapeModel: Tape {
        get {
            Tape(
                id: id,
                nameID: Int(nameID),
                alphabet: alphabet,
                input: input,
                headIndex: Int(headIndex),
                components: wrappedComponents.map { $0.componentModel }
            )
        }
        set {
            id = newValue.id
            nameID = Int16(newValue.nameID)
            alphabet = newValue.alphabet
            input = newValue.input
            headIndex = Int16(newValue.headIndex)
            
            components = []
            for component in newValue.components {
                let newTapeComponent = TapeComponentEntity(context: DataManager.shared.container.viewContext)
                newTapeComponent.componentModel = component
                addToComponents(newTapeComponent)
            }
        }
    }
}

// MARK: Generated accessors for components
extension TapeEntity {

    @objc(addComponentsObject:)
    @NSManaged public func addToComponents(_ value: TapeComponentEntity)

    @objc(removeComponentsObject:)
    @NSManaged public func removeFromComponents(_ value: TapeComponentEntity)

    @objc(addComponents:)
    @NSManaged public func addToComponents(_ values: NSSet)

    @objc(removeComponents:)
    @NSManaged public func removeFromComponents(_ values: NSSet)

}

extension TapeEntity : Identifiable {

}
