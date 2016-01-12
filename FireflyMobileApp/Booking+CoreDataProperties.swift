//
//  Booking+CoreDataProperties.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/12/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Booking {

    @NSManaged var username: String?
    @NSManaged var pnr: String?
    @NSManaged var flightDate: String?
    @NSManaged var contactEmail: String?

}
