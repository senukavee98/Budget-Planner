//
//  Budget+CoreDataProperties.swift
//  masterDet
//
//  Created by user192220 on 5/27/21.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var amount: Double
    @NSManaged public var boarderColor: String?
    @NSManaged public var category_name: String?
    @NSManaged public var color: String?
    @NSManaged public var notes: String?
    @NSManaged public var expences: NSSet?

}

// MARK: Generated accessors for expences
extension Budget {

    @objc(addExpencesObject:)
    @NSManaged public func addToExpences(_ value: Expence)

    @objc(removeExpencesObject:)
    @NSManaged public func removeFromExpences(_ value: Expence)

    @objc(addExpences:)
    @NSManaged public func addToExpences(_ values: NSSet)

    @objc(removeExpences:)
    @NSManaged public func removeFromExpences(_ values: NSSet)

}

extension Budget : Identifiable {

}
