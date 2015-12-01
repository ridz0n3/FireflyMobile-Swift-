//
//  Constant.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/20/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

let key = "owNLfnLjPvwbQH3hUmj5Wb7wBIv83pR7" // length == 3
let iv = "owNLfnLjPvwbQH3h" // length == 16
let kBaseURL = "http://fyapidev.me-tech.com.my/api/"

class Constant: NSObject {
    
}

func nullIfEmpty(value : AnyObject?) -> AnyObject? {
    if value is NSNull {
        return ""
    } else {
        return value
    }
}

func nilIfEmpty(value : AnyObject?) -> AnyObject? {
    if value == nil {
        return ""
    } else {
        return value
    }
}