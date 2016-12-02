//
//  AppDelegate.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import CoreData
import RealmSwift
import Realm
import SwiftyJSON
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let baseView = BaseViewController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        if (launchOptions != nil){
            defaults.setValue(launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as! [NSObject:AnyObject], forKey: "notif")
        }else{
            defaults.setValue("", forKey: "notif")
        }
        
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeled] = CustomFloatLabelCell.self
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorCheckbox] = "CustomCheckBoxCell"
        
        let homeStoryBoard = UIStoryboard(name: "SplashScreen", bundle: nil)
        let navigationController = homeStoryBoard.instantiateViewControllerWithIdentifier("LaunchScreenVC")
        self.window?.rootViewController = navigationController
        
        let config = RLMRealmConfiguration.defaultConfiguration()
        config.schemaVersion = 11
        config.migrationBlock = { (migration, oldSchemaVersion) in
            // nothing to do
        }

        if try! LoginManager.sharedInstance.isLogin(){
            let userinfo = defaults.objectForKey("userInfo") as! [String: AnyObject]
            let username = userinfo["username"] as! String
            Crashlytics.sharedInstance().setUserEmail("\(username)")
        }
        
        RLMRealmConfiguration.setDefaultConfiguration(config)
        RemoteNotificationManager.sharedInstance.registerNotificationCategory()
        RemoteNotificationManager.sharedInstance.registerGCM()
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        RemoteNotificationManager.sharedInstance.getGCMToken(deviceToken)
        
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("identifier received: \(identifier)")
       // UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=Bluetooth")!)
       // showErrorMessage(identifier!)
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        let alert = userInfo["aps"]!
        let message = alert["alert"]!!
        
        showNotif(message["title"] as! String, message : message["body"] as! String)
        //print(message["body"] as! String)
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Couldn't register: \(error)")
        defaults.setValue("", forKey: "token")
        InitialLoadManager.sharedInstance.load()
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

