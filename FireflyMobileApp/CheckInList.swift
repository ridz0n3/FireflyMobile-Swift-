//
//  CheckInList.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 4/20/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import Foundation
import RealmSwift

class CheckInList: Object {
    
    dynamic var pnr = ""
    dynamic var departureStationCode = ""
    dynamic var arrivalStationCode = ""
    dynamic var departureDateTime = NSDate()
    dynamic var departureDayDate = ""
}
