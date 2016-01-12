//
//  InitialLoadManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/11/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class InitialLoadManager {
    
    static let sharedInstance = InitialLoadManager()
    
    func load(){
        let defaults = NSUserDefaults.standardUserDefaults()
        var existDataVersion = String()
        
        if (defaults.objectForKey("dataVersion") != nil){
            existDataVersion = defaults.objectForKey("dataVersion") as! String
        }else{
            existDataVersion = ""
        }
        
        FireFlyProvider.request(.Loading("","","","",UIDevice.currentDevice().systemVersion,UIDevice.currentDevice().identifierForVendor!.UUIDString,"Apple",UIDevice.currentDevice().modelName,existDataVersion)) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    var title = NSArray()
                    var flight = NSArray()
                    var country = NSArray()
                    var state = NSArray()
                    var banner = String()
                    var signature = String()
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] != nil{
                        if json["status"].string  == "success"{
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            
                            if (defaults.objectForKey("dataVersion") != nil){
                                existDataVersion = defaults.objectForKey("dataVersion") as! String
                            }else{
                                existDataVersion = "0"
                            }
                            
                            let dataVersion = json["data_version"].string
                            
                            if existDataVersion != dataVersion{
                                
                                title = json["data_title"].object as! NSArray
                                flight = json["data_market"].object as! NSArray
                                country = json["data_country"].object as! NSArray
                                state = json["data_state"].object as! NSArray
                                
                                defaults.setObject(dataVersion, forKey: "dataVersion")
                                defaults.setObject(title , forKey: "title")
                                defaults.setObject(flight, forKey: "flight")
                                defaults.setObject(country, forKey: "country")
                                defaults.setObject(state, forKey: "state")
                                
                            }
                            
                            if json["banner_promo"].string == ""{
                                banner = json["banner_default"].string!
                            }else{
                                banner = json["banner_promo"].string!
                            }
                            
                            signature = json["signature"].string!
                            
                            defaults.setObject(signature, forKey: "signatureLoad")
                            defaults.setObject(banner, forKey: "banner")
                            defaults.synchronize()
                            
                            NSNotificationCenter.defaultCenter().postNotificationName("reloadHome", object: nil)
                        }
                        else{
                            print(String(format: "%@ \n%@", json["status"].string!, json["message"].string!))
                        }
                    }
                    else{
                        print(result)
                    }
                }
                catch {
                    
                }
            case .Failure(let errorResult):
                print (errorResult)
            }
        }

    }

}
