//
//  Expence+CoreDataProperties.swift
//  masterDet
//
//  Created by user192220 on 5/27/21.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
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
