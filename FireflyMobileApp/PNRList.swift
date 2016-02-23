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
    let boardingPass = List<BoardingPass>()
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
