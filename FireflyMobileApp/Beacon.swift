//
//  Beacon.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/9/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

struct BeaconConstant {
    static let nameKey = "name"
    static let uuidKey = "uuid"
    static let majorKey = "major"
    static let minorKey = "minor"
}

class Beacon: NSObject, NSCoding {
    let name: String
    let uuid: NSUUID
    let majorValue: CLBeaconMajorValue
    let minorValue: CLBeaconMinorValue
    dynamic var lastSeenBeacon: CLBeacon?
    
    init(name: String, uuid: NSUUID, majorValue: CLBeaconMajorValue, minorValue: CLBeaconMinorValue) {
        self.name = name
        self.uuid = uuid
        self.majorValue = majorValue
        self.minorValue = minorValue
    }
    
    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        if let aName = aDecoder.decodeObjectForKey(BeaconConstant.nameKey) as? String {
            name = aName
        }
        else {
            name = ""
        }
        if let aUUID = aDecoder.decodeObjectForKey(BeaconConstant.uuidKey) as? NSUUID {
            uuid = aUUID
        }
        else {
            uuid = NSUUID()
        }
        majorValue = UInt16(aDecoder.decodeIntegerForKey(BeaconConstant.majorKey))
        minorValue = UInt16(aDecoder.decodeIntegerForKey(BeaconConstant.minorKey))
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: BeaconConstant.nameKey)
        aCoder.encodeObject(uuid, forKey: BeaconConstant.uuidKey)
        aCoder.encodeInteger(Int(majorValue), forKey: BeaconConstant.majorKey)
        aCoder.encodeInteger(Int(minorValue), forKey: BeaconConstant.minorKey)
    }
    
}

func ==(item: Beacon, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.UUIDString == item.uuid.UUIDString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}
