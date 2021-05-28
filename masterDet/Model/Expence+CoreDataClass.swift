//
//  Expence+CoreDataClass.swift
//  masterDet
//
//  Created by user192220 on 5/27/21.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//
//

import Foundation
import CoreData


public class Expence: NSManagedObject {
    
    var budget: [Budget] = []
    var expenses: [Expence] = []
    var selectedCategory: Budget?
    

}
