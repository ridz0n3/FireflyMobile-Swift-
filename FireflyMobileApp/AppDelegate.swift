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
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let baseView = BaseViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        if launchOptions != nil{
            
            defaults.set(launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification], forKey: "notif")
            defaults.synchronize()
            
        }else{
            
            defaults.setValue("", forKey: "notif")
            defaults.synchronize()
            
        }
        
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeled] = CustomFloatLabelCell.self
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorCheckbox] = "CustomCheckBoxCell"
        
        let homeStoryBoard = UIStoryboard(name: "SplashScreen", bundle: nil)
        let navigationController = homeStoryBoard.instantiateViewController(withIdentifier: "LaunchScreenVC")
        self.window?.rootViewController = navigationController
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 12,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        if try! LoginManager.sharedInstance.isLogin(){
            let userinfo = defaults.object(forKey: "userInfo") as! [String: AnyObject]
            let username = userinfo["username"] as! String
            Crashlytics.sharedInstance().setUserEmail("\(username)")
        }
        
        //RLMRealmConfiguration.setDefault(config)
        RemoteNotificationManager.sharedInstance.registerNotificationCategory()
        RemoteNotificationManager.sharedInstance.registerGCM()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        RemoteNotificationManager.sharedInstance.getGCMToken(deviceToken: deviceToken)
    
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        let aps = userInfo["aps"]! as! NSDictionary
        let alert = aps["alert"] as AnyObject
        
        if alert.classForCoder != NSString.classForCoder(){
            
            let message = alert as! NSDictionary
            
            showNotif(message["title"] as! String, message: message["body"] as! String)
            
        }else{
            
            showNotif("Message", message: alert as! String)
            
        }
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn't register: \(error)")
        defaults.setValue("", forKey: "token")
        InitialLoadManager.sharedInstance.load()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

