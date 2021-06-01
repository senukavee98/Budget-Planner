//
//  Expence+CoreDataProperties.swift
//  masterDet
//
//  Created by user192220 on 5/17/25.
//
//

import Foundation
import CoreData


extension Expence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expence> {
        return NSFetchRequest<Expence>(entityName: "Expence")
    }

    @NSManaged public var due_date: Date?
    @NSManaged public var expence_amount: Double
    @NSManaged public var expence_name: String?
    @NSManaged public var isRemender: Bool
    @NSManaged public var notes: String?
    @NSManaged public var occurrence: String?
    @NSManaged public var budgetCatoegory: Budget?

}

extension Expence : Identifiable {

}
