//
//  FamilyAndFriendList.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/13/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import Foundation
import RealmSwift

class FamilyAndFriendList: Object {
    
    dynamic var email = ""
    let familyList = List<FamilyAndFriendData>()
    
}
