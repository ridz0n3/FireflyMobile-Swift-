//
//  PNRList.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/23/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import Foundation
import RealmSwift

class PNRList: Object {
    
    dynamic var pnr = ""
    dynamic var departureStationCode = ""
    dynamic var arrivalStationCode = ""
    dynamic var departureDateTime = Date()
    dynamic var departureDayDate = ""
    let boardingPass = List<BoardingPassList>()
    
}
