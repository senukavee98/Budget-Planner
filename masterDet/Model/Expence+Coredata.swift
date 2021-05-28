//
//  Expence+Coredata.swift
//  masterDet
//
//  Created by user192220 on 5/27/21.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//

import Foundation
import CoreData


extension Expence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expence> {
        return NSFetchRequest<Expence>(entityName: "Task")
    }

    @NSManaged public var dueDateRaw: Date?
    @NSManaged public var isAddedNotification: Bool
    @NSManaged public var notes: String?
    @NSManaged public var progress: Float
    @NSManaged public var startDateRaw: Date?
    @NSManaged public var taskId: String?
    @NSManaged public var title: String?
    @NSManaged public var assignment: Assignment?

}

extension Task : Identifiable {

}
