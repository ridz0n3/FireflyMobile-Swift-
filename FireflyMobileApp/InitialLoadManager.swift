//
//  InitialLoadManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/11/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MFSideMenu

class InitialLoadManager {
    
    static let sharedInstance = InitialLoadManager()
    
    func load(){
        var existDataVersion = String()
        
        if (defaults.objectForKey("dataVersion") != nil){
            existDataVersion = defaults.objectForKey("dataVersion") as! String
        }else{
            existDataVersion = ""
        }
        var username = String()
        var password = String()
        
        if try! LoginManager.sharedInstance.isLogin(){
            let userinfo = defaults.objectForKey("userInfo") as! [String: AnyObject]
            username = userinfo["username"] as! String
            password = userinfo["password"] as! String
        }
        let deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString//defaults.objectForKey("token") as! String
        //print(deviceId)
        
        initializeGA()
        FireFlyProvider.request(.Loading("",username,password,"",UIDevice.currentDevice().systemVersion,deviceId!,"Apple",UIDevice.currentDevice().modelName,existDataVersion)) { (result) -> () in
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
                            let socialLink = json["social_media_link"].dictionary
                            
                            defaults.setObject(socialLink!["instagram"]?.string, forKey: "instagram")
                            defaults.setObject(socialLink!["twitter"]?.string, forKey: "twitter")
                            defaults.setObject(socialLink!["facebookScreen"]?.string, forKey: "facebook")
                            
                            defaults.setObject(json["banner_module"].string, forKey: "module")
                            defaults.setObject(signature, forKey: "signatureLoad")
                            defaults.setObject(banner, forKey: "banner")
                            defaults.synchronize()
                            self.checkForAppUpdate()
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
                    
                }//
            case .Failure(let failureResult):
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
        }

    }
    
    func initializeGA(){
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
    }
    
    func checkForAppUpdate(){
        
        let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let buildVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
        
        if appVersion != "1.0"{
            
            UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().translucent = false
            // Override point for customization after application launch.
            
            let viewController = UIApplication.sharedApplication().delegate as! AppDelegate
            
            UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().translucent = false
            
            let storyboard = UIStoryboard(name: "NewUpdate", bundle: nil)
            let aboutVC = storyboard.instantiateViewControllerWithIdentifier("NewUpdateVC") as! UINavigationController
            
            viewController.window?.rootViewController = aboutVC
            
        }else{
            
            UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().translucent = false
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let container = storyboard.instantiateViewControllerWithIdentifier("MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
            
            let viewController = UIApplication.sharedApplication().delegate as! AppDelegate
            
            viewController.window?.rootViewController = container
            
            let sideMenuVC = storyboard.instantiateViewControllerWithIdentifier("sideMenuVC") as! SideMenuTableViewController
            
            let homeStoryBoard = UIStoryboard(name: "Home", bundle: nil)
            let navigationController = homeStoryBoard.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
            
            container.leftMenuViewController = sideMenuVC
            container.centerViewController = navigationController
            
            container.leftMenuWidth = UIScreen.mainScreen().applicationFrame.size.width - 100
        }
        
    }

}
