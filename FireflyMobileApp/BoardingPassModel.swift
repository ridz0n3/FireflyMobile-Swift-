//
//  BoardingPassModel.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/22/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import RealmSwift
import Foundation
import Realm

class BoardingPassModel: Object {
    
    dynamic var userId = ""
    let pnr = List<PNRList>()
    
}
