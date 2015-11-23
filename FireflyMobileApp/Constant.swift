//
//  Constant.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/20/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

let kBaseURL = "http://fyapidev.me-tech.com.my/api/"

class Constant: NSObject {
    
}

func emptyIfNull(foo : String) -> String{
    if foo.isEmpty{
        return ""
    }else{
        return foo
    }
}
