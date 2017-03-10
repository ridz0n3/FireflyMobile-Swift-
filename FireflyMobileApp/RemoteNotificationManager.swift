//
//  RemoteNotificationManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/30/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

// [START ios_10_message_handling]
@available(iOS 10, *)

extension RemoteNotificationManager : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        let aps = userInfo["aps"]! as! NSDictionary
        let alert = aps["alert"] as AnyObject
        
        if alert.classForCoder != NSString.classForCoder(){
            
            let message = alert as! NSDictionary
            
            showNotif(message["title"] as! String, message: message["body"] as! String)
            
        }else{
            
            showNotif("Message", message: alert as! String)
            
        }
        
        // Print full message.
        //print(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        
        /*let aps = userInfo["aps"]! as! NSDictionary
        let alert = aps["alert"] as AnyObject
        
        if alert.classForCoder != NSString.classForCoder(){
            
            let message = alert as! NSDictionary
            
            showNotif(message["title"] as! String, message: message["body"] as! String)
            
        }else{
            
            showNotif("Message", message: alert as! String)
            
        }
        */ 
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        //print(userInfo)
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension RemoteNotificationManager : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}

class RemoteNotificationManager: NSObject{
    
    static let sharedInstance = RemoteNotificationManager()
    
    func registerNotificationCategory(){
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    func registerGCM(){
        
        let firebasePlistFileName = "GoogleService-Info"
        let firbaseOptions = FIROptions(contentsOfFile: Bundle.main.path(forResource: firebasePlistFileName, ofType: "plist"))
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
        
        FIRApp.configure(with: firbaseOptions!)
        
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token in tokenRefreshNotification: \(refreshedToken)")
            connectToFcm()
            InitialLoadManager.sharedInstance.load()
        }else{
            // Add observer for InstanceID token refresh callback.
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.tokenRefreshNotification),
                                                   name: .firInstanceIDTokenRefresh,
                                                   object: nil)
        }
        
        
        
    }
    
    func getGCMToken(deviceToken:Data){
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token in tokenRefreshNotification: \(refreshedToken)")
            connectToFcm()
            InitialLoadManager.sharedInstance.load()
        }

        
        
    }

    func tokenRefreshNotification(_ notification: Notification) {
        // Connect to FCM since connection may have failed when attempted before having a token.
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token in tokenRefreshNotification: \(refreshedToken)")
            connectToFcm()
            InitialLoadManager.sharedInstance.load()
        }
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM in connect To FCM. \(error)")
            } else {
                print("Connected to FCM. in connect To FCM")
            }
        }
    }

}
