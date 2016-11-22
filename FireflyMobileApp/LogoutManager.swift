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
        
        let signature = defaults.object(forKey: "signatureLoad") as! String
        showLoading()
        FireFlyProvider.request(.Logout(signature), completion: { (result) -> () in
            
            switch result {
            case .success(let successResult):
                do {
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if  json["status"].string == "success"{
                    
                        // Delete all objects from the realm
                        /*try! realm.write {
                            realm.deleteAll()
                        }*/
                        
                        defaults.set("", forKey: "userInfo")
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
                
            case .failure(let failureResult):
                hideLoading()
                showErrorMessage(failureResult.localizedDescription)
            }
            
        })

        
    }
}
