//
//  TapeEntityEntity+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 25.06.2022.
//
//

import Foundation
import CoreData


extension TapeEntityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TapeEntityEntity> {
        return NSFetchRequest<TapeEntityEntity>(entityName: "TapeEntityEntity")
    }

    @NSManaged public var headIndex: Int16
    @NSManaged public var input: String
    @NSManaged public var alphabet: String
    @NSManaged public var nameID: Int16
    @NSManaged public var id: UUID
    @NSManaged public var components: NSSet
    @NSManaged public var algorithm: AlgorithmEntity?
    
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
                let newTapeComponent = TapeComponentEntity()
                newTapeComponent.componentModel = component
                components.adding(newTapeComponent)
            }
        }
    }

}

// MARK: Generated accessors for components
extension TapeEntityEntity {

    @objc(addComponentsObject:)
    @NSManaged public func addToComponents(_ value: TapeComponentEntity)

    @objc(removeComponentsObject:)
    @NSManaged public func removeFromComponents(_ value: TapeComponentEntity)

    @objc(addComponents:)
    @NSManaged public func addToComponents(_ values: NSSet)

    @objc(removeComponents:)
    @NSManaged public func removeFromComponents(_ values: NSSet)

}

extension TapeEntityEntity : Identifiable {

}
