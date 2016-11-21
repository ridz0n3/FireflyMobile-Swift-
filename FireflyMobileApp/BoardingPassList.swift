//
//  BoardingPassList.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/24/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import Foundation
import RealmSwift

class BoardingPassList: Object {
    
    dynamic var name = ""
    dynamic var departureStation = ""
    dynamic var arrivalStation = ""
    dynamic var departureDate = ""
    dynamic var departureTime = ""
    dynamic var boardingTime = ""
    dynamic var fare = ""
    dynamic var flightNumber = ""
    dynamic var SSR = ""
    dynamic var QRCodeURL = Data()
    dynamic var recordLocator = ""
    dynamic var arrivalStationCode = ""
    dynamic var departureStationCode = ""
    
}
