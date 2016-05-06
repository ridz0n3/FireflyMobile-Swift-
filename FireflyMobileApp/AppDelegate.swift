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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let baseView = BaseViewController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeled] = CustomFloatLabelCell.self
        
        let homeStoryBoard = UIStoryboard(name: "SplashScreen", bundle: nil)
        let navigationController = homeStoryBoard.instantiateViewControllerWithIdentifier("LaunchScreenVC")
        self.window?.rootViewController = navigationController
        
        let config = RLMRealmConfiguration.defaultConfiguration()
        config.schemaVersion = 10
        config.migrationBlock = { (migration, oldSchemaVersion) in
            // nothing to do
        }
        
        RLMRealmConfiguration.setDefaultConfiguration(config)
        RemoteNotificationManager.sharedInstance.registerNotificationCategory()
        RemoteNotificationManager.sharedInstance.registerGCM()
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        RemoteNotificationManager.sharedInstance.getGCMToken(deviceToken)
        
        var newToken = deviceToken.description
        newToken = newToken.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        newToken = newToken.stringByReplacingOccurrencesOfString(" ", withString: "")
        
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("identifier received: \(identifier)")
       // UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=Bluetooth")!)
       // showErrorMessage(identifier!)
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Message: \(userInfo)")
        
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

