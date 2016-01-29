//
//  PushNotificationManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/29/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class PushNotificationManager: NSObject {

    static let sharedInstance = PushNotificationManager()
    
    func sentDeviceToken(token : String){
        
        print(token)
        let params = NSMutableDictionary()
        params.setValue("join", forKey: "cmd")
        params.setValue("ridz@gmail.com", forKey: "user_id")
        params.setValue(token, forKey: "token")
        params.setValue("Ridzuan", forKey: "name")
        params.setValue("test", forKey: "code")
        
        
        let manager = WSDLNetworkManager()
        manager.sharedClient().sentData("/api.php", withParams: params)
        
        
    }
    
}
