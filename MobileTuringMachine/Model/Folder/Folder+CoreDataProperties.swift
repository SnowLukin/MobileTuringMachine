//
//  Folder+CoreDataProperties.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.07.2022.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String
    @NSManaged public var algorithms: NSSet?
    @NSManaged public var parentFolder: Folder?
    @NSManaged public var subFolders: NSSet?

    public var wrappedSubFolders: [Folder] {
        if let subFolders = subFolders {
            let folders = subFolders as? Set<Folder> ?? []
            return folders.sorted(by: {
                $0.name < $1.name
            })
        }
        return []
    }
    
    public var wrappedAlgorithms: [Algorithm] {
        if let algorithms = algorithms {
            let entities = algorithms as? Set<Algorithm> ?? []
            return entities.sorted(by: {
                $0.name < $1.name
            })
        }
        return []
    }
    
    func initValues(name: String, parentFolder: Folder? = nil,
                    algorithms: [Algorithm] = [], subFolders: [Folder] = []) {
        self.name = name
        self.parentFolder = parentFolder
        self.subFolders = NSSet(array: subFolders)
        self.algorithms = NSSet(array: algorithms)
    }
}

// MARK: Generated accessors for algorithms
extension Folder {

    @objc(addAlgorithmsObject:)
    @NSManaged public func addToAlgorithms(_ value: Algorithm)

    @objc(removeAlgorithmsObject:)
    @NSManaged public func removeFromAlgorithms(_ value: Algorithm)

    @objc(addAlgorithms:)
    @NSManaged public func addToAlgorithms(_ values: NSSet)

    @objc(removeAlgorithms:)
    @NSManaged public func removeFromAlgorithms(_ values: NSSet)

}

// MARK: Generated accessors for subFolders
extension Folder {

    @objc(addSubFoldersObject:)
    @NSManaged public func addToSubFolders(_ value: Folder)

    @objc(removeSubFoldersObject:)
    @NSManaged public func removeFromSubFolders(_ value: Folder)

    @objc(addSubFolders:)
    @NSManaged public func addToSubFolders(_ values: NSSet)

    @objc(removeSubFolders:)
    @NSManaged public func removeFromSubFolders(_ values: NSSet)

}

extension Folder : Identifiable {

}
