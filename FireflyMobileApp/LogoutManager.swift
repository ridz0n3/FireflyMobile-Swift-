//
//  LogoutManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/25/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class LogoutManager: NSObject {

    static let sharedInstance = LogoutManager()
    
    func logout(){
        
        let signature = defaults.objectForKey("signatureLoad") as! String
        showLoading()
        FireFlyProvider.request(.Logout(signature), completion: { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if  json["status"].string == "success"{
                    
                        // Delete all objects from the realm
                        /*try! realm.write {
                            realm.deleteAll()
                        }*/
                        
                        defaults.setObject("", forKey: "userInfo")
                        defaults.synchronize()
                        InitialLoadManager.sharedInstance.load()
                        
                    }else if json["status"].string == "401"{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                        InitialLoadManager.sharedInstance.load()
                    }else{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                    }
                    
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
            
        })

        
    }
}
