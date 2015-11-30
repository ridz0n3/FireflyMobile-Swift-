//
//  AppDelegate.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import MFSideMenu
import XLForm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let baseView = BaseViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        load()
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        let settings = UIUserNotificationSettings(forTypes: .Alert , categories: nil) //(forTypes: .Alert, .Badge, .Sound , categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().translucent = false
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let container = storyboard.instantiateViewControllerWithIdentifier("MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        
        self.window?.rootViewController = container
        
        let sideMenuVC = storyboard.instantiateViewControllerWithIdentifier("sideMenuVC") as! SideMenuTableViewController
        
        let homeStoryBoard = UIStoryboard(name: "Home", bundle: nil)
        let navigationController = homeStoryBoard.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
        
        container.leftMenuViewController = sideMenuVC
        container.centerViewController = navigationController
        
        container.leftMenuWidth = UIScreen.mainScreen().applicationFrame.size.width - 100

        return true
    }
    
    func load(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var existDataVersion = String()
        
        if (defaults.objectForKey("dataVersion") != nil){
            existDataVersion = defaults.objectForKey("dataVersion") as! String
        }else{
            existDataVersion = ""
        }
        
        let request = WSDLNetworkManager()
        let parameters:[String:AnyObject] = [
            "signature": "",
            "username": "",
            "password": "",
            "sdkVersion": "",
            "version": "",
            "deviceId": "",
            "brand": "",
            "model": "",
            "dataVersion": existDataVersion,
        ]
        
        request.sharedClient().createRequestWithService("Loading", withParams: parameters) { (result) -> Void in
            
            var title = NSArray()
            var flight = NSArray()
            var country = NSArray()
            var state = NSArray()
            var banner = String()

            if result["status"] != nil{
                if result["status"] as! String  == "success"{
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    if (defaults.objectForKey("dataVersion") != nil){
                        existDataVersion = defaults.objectForKey("dataVersion") as! String
                    }else{
                        existDataVersion = "0"
                    }
                    
                    let dataVersion = result["data_version"] as! String
                    
                    if existDataVersion != dataVersion{
                        
                        title = result["data_title"] as! NSArray
                        flight = result["data_market"] as! NSArray
                        country = result["data_country"] as! NSArray
                        state = result["data_state"] as! NSArray
                        
                        defaults.setObject(dataVersion, forKey: "dataVersion")
                        defaults.setObject(title, forKey: "title")
                        defaults.setObject(flight, forKey: "flight")
                        defaults.setObject(country, forKey: "country")
                        defaults.setObject(state, forKey: "state")
                        
                    }
                    
                    if result["banner_promo"] as! String == ""{
                        banner = result["banner_default"] as! String
                    }else{
                        banner = result["banner_promo"] as! String
                    }
                    
                    defaults.setObject(banner, forKey: "banner")
                    defaults.synchronize()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadHome", object: nil)
                }else{
                    
                    print(String(format: "%@ \n%@", result["status"] as! String, result["message"] as! String))
                    //self.baseView.showToastMessage(String(format: "%@ \n%@", result["status"] as! String, result["message"] as! String))
                    
                }
            }else{
                print(result.localizedDescription)
            }
        }

    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Got token data! \(deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Couldn't register: \(error)")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

