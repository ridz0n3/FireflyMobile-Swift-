//
//  LoginManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/5/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class LoginManager {

    static let sharedInstance = LoginManager()
    
    func isLogin() throws -> Bool {
        
        if (defaults.objectForKey("userInfo") != nil){
            
            if defaults.objectForKey("userInfo")?.count != nil{
                return true
            }else{
                return false
            }
            
        }
        
        return false
    }
    
}
