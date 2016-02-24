//
//  UserList.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/24/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import Foundation
import RealmSwift

class UserList: Object {
    
    dynamic var userId = ""
    let pnr = List<PNRList>()
    
}
