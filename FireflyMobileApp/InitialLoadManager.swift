//
//  InitialLoadManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/11/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SlideMenuControllerSwift
import Crashlytics
import Firebase
class InitialLoadManager {
    
    static let sharedInstance = InitialLoadManager()
    
    func load(){
        
        if defaults.object(forKey: "first") == nil{
            
            if try! LoginManager.sharedInstance.isLogin(){
                defaults.set("", forKey: "userInfo")
                defaults.set("Y", forKey: "first")
                defaults.set("0", forKey: "dataVersion")
                defaults.synchronize()

            }else{
                defaults.set("0", forKey: "dataVersion")
            }
            
        }
        
        var existDataVersion = String()
        if (defaults.object(forKey: "dataVersion") != nil){
            existDataVersion = defaults.object(forKey: "dataVersion") as! String
        }else{
            existDataVersion = "0"
        }
        var username = String()
        var password = String()
        
        if try! LoginManager.sharedInstance.isLogin(){
            let userinfo = defaults.object(forKey: "userInfo") as! [String: AnyObject]
            username = userinfo["username"] as! String
            password = userinfo["password"] as! String
            Crashlytics.sharedInstance().setUserEmail(username)
        }
        
        let gcmKey = FIRInstanceID.instanceID().token()
        
        CLSLogv("Parameter: %@ %@ %@ %@ %@ %@ %@ %@", getVaList([username,password,UIDevice.current.systemVersion,deviceId!,"Apple",UIDevice.current.modelName,existDataVersion, gcmKey!]))
        
        FireFlyProvider.request(.Loading("",username,password,"",UIDevice.current.systemVersion,deviceId!,"Apple",UIDevice.current.modelName,existDataVersion, gcmKey!)) { (result) -> () in
            switch result {
            case .success(let successResult):
                do {
                    var title = NSArray()
                    var flight = NSArray()
                    var country = NSArray()
                    var state = NSArray()
                    var banner = String()
                    var signature = String()
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if json["status"] != nil{
                        if json["status"].string  == "success"{
                            
                            if (defaults.object(forKey: "dataVersion") != nil){
                                existDataVersion = defaults.object(forKey: "dataVersion") as! String
                            }else{
                                existDataVersion = "0"
                            }
                            
                            let dataVersion = json["data_version"].string
                            
                            if existDataVersion != dataVersion{
                                
                                title = json["data_title"].object as! NSArray
                                flight = json["data_market"].object as! NSArray
                                country = json["data_country"].object as! NSArray
                                state = json["data_state"].object as! NSArray
                                
                                defaults.set(dataVersion, forKey: "dataVersion")
                                defaults.set(title , forKey: "title")
                                defaults.set(flight, forKey: "flight")
                                defaults.set(country, forKey: "country")
                                defaults.set(state, forKey: "state")
                                
                            }
                            
                            if json["banner_promo"].string == ""{
                                banner = json["banner_default"].string!
                            }else{
                                banner = json["banner_promo"].string!
                            }
                            
                            signature = json["signature"].string!
                            let socialLink = json["social_media_link"].dictionary
                            
                            defaults.set(socialLink!["instagram"]?.string, forKey: "instagram")
                            defaults.set(socialLink!["twitter"]?.string, forKey: "twitter")
                            defaults.set(socialLink!["facebookScreen"]?.string, forKey: "facebook")
                            
                            defaults.set("true", forKey: "firstInstall")
                            defaults.set(json["banner_module"].string, forKey: "module")
                            defaults.set(nilIfEmpty(json["banner_url"].string as AnyObject?), forKey: "url")
                            defaults.set(signature, forKey: "signatureLoad")
                            defaults.set(banner, forKey: "banner")
                            defaults.set(json["data_version_mobile"].dictionaryObject, forKey: "mobileVersion")
                            defaults.synchronize()
                            self.checkForAppUpdate()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHome"), object: nil)
                        }
                        else if json["status"].string == "force_logout"{
                            defaults.set("", forKey: "userInfo")
                            defaults.synchronize()
                            self.load()
                            print(String(format: "%@ \n%@", json["status"].string!, json["message"].string!))
                        }else if json["status"].string == "503"{
                            showErrorMessage(json["message"].string!)
                        }else{
                            showRetryMessage(json["message"].string!)
                        }
                        hideLoading()
                    }
                    else{
                        print(result)
                    }
                }
                catch {
                    showRetryMessage("Unable to connect the server")
                }//
            case .failure(let failureResult):
                
                if defaults.object(forKey: "firstInstall") != nil{
                    UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                    UINavigationBar.appearance().isTranslucent = false
                    
                    let viewController = UIApplication.shared.delegate as! AppDelegate
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftSideMenuViewController
                    let homeStoryBoard = UIStoryboard(name: "Home", bundle: nil)
                    let navigationController = homeStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                    
                    let nvc: UINavigationController = UINavigationController(rootViewController: navigationController)
                    
                    let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: sideMenuVC)
                    slideMenuController.automaticallyAdjustsScrollViewInsets = true
                    slideMenuController.delegate = navigationController
                    viewController.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                    viewController.window?.rootViewController = slideMenuController
                    viewController.window?.makeKeyAndVisible()
                }else{
                    showRetryMessage(failureResult.localizedDescription)
                }
                
                //if failureResult.nsError.code == -1001 || failureResult.nsError.code == -1009{
                
                //}else{
                //    showErrorMessage(failureResult.localizedDescription)
                //}
                
            }
        }

    }
    
    func initializeGA(){
       /* // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release*/
    }
    
    func checkForAppUpdate(){
        
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        let version = defaults.object(forKey: "mobileVersion") as! Dictionary<String,AnyObject>
        
        if appVersion != version["version"] as! String && version["force_update"] as! String == "Y"{
            
            UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().isTranslucent = false
            // Override point for customization after application launch.
            
            let viewController = UIApplication.shared.delegate as! AppDelegate
            
            UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().isTranslucent = false
            
            let storyboard = UIStoryboard(name: "NewUpdate", bundle: nil)
            let aboutVC = storyboard.instantiateViewController(withIdentifier: "NewUpdateVC") as! UINavigationController
            
            viewController.window?.rootViewController = aboutVC
            
        }else{
            
            UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().isTranslucent = false
            
            let viewController = UIApplication.shared.delegate as! AppDelegate
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftSideMenuViewController
            let homeStoryBoard = UIStoryboard(name: "Home", bundle: nil)
            let navigationController = homeStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            
            let nvc: UINavigationController = UINavigationController(rootViewController: navigationController)
            
            let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: sideMenuVC)
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
            slideMenuController.delegate = navigationController
            viewController.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
            viewController.window?.rootViewController = slideMenuController
            viewController.window?.makeKeyAndVisible()
            
        }
        
    }

}
