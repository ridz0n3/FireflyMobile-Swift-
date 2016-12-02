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

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        //print(userInfo)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        //print(userInfo)
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        
        showInfo("t")
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let baseView = BaseViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
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
        
        let config = RLMRealmConfiguration.default()
        config.schemaVersion = 11
        config.migrationBlock = { (migration, oldSchemaVersion) in
            // nothing to do
        }

        if try! LoginManager.sharedInstance.isLogin(){
            let userinfo = defaults.object(forKey: "userInfo") as! [String: AnyObject]
            let username = userinfo["username"] as! String
            Crashlytics.sharedInstance().setUserEmail("\(username)")
        }
        
        Fabric.with([Crashlytics.self])
        
        RLMRealmConfiguration.setDefault(config)
        RemoteNotificationManager.sharedInstance.registerNotificationCategory()
        RemoteNotificationManager.sharedInstance.registerGCM()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        RemoteNotificationManager.sharedInstance.getGCMToken(deviceToken: deviceToken)
        InitialLoadManager.sharedInstance.load()
        
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

