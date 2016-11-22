//
//  RemoteNotificationManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/30/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class RemoteNotificationManager: NSObject, GGLInstanceIDDelegate, GCMReceiverDelegate {

    static let sharedInstance = RemoteNotificationManager()
    
    var connectedToGCM = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    func registerNotificationCategory(){
        
        let completeAction = UIMutableUserNotificationAction()
        completeAction.identifier = "Close"
        completeAction.title = "Close"
        completeAction.activationMode = .Background
        completeAction.authenticationRequired = false
        completeAction.destructive = true
        
        let remindAction = UIMutableUserNotificationAction()
        remindAction.identifier = "Turn_On"
        remindAction.title = "Open"
        remindAction.activationMode = .Foreground
        remindAction.destructive = false
        
        let todoCategory = UIMutableUserNotificationCategory()
        todoCategory.identifier = "Check_Bluetooth"
        todoCategory.setActions([remindAction], forContext: .Minimal)
        
        
        //geofence
        let noNotifyAction = UIMutableUserNotificationAction()
        noNotifyAction.identifier = "geofence"
        noNotifyAction.title = "Open"
        noNotifyAction.activationMode = .Background
        noNotifyAction.destructive = true
        
        let geoCategory = UIMutableUserNotificationCategory()
        geoCategory.identifier = "Geofence"
        geoCategory.setActions([noNotifyAction], forContext: .Minimal)
        
        let notifyAction = UIMutableUserNotificationAction()
        notifyAction.identifier = "DepartureScan"
        notifyAction.title = "Ok"
        notifyAction.activationMode = .Background
        notifyAction.destructive = true
        
        let beaconCategory = UIMutableUserNotificationCategory()
        beaconCategory.identifier = "DepartureGate"
        beaconCategory.setActions([notifyAction], forContext: .Minimal)
        
        let reminderAction = UIMutableUserNotificationAction()
        reminderAction.identifier = "Reminder"
        reminderAction.title = "Ok"
        reminderAction.activationMode = .Foreground
        reminderAction.destructive = true
        
        let reminderCategory = UIMutableUserNotificationCategory()
        reminderCategory.identifier = "Reminder"
        reminderCategory.setActions([reminderAction], forContext: .Minimal)
        
        let notifSetting:UIUserNotificationType = [.Badge, .Alert, .Sound]
        UIApplication.sharedApplication()
            .registerForRemoteNotifications()
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: notifSetting, categories: NSSet(array: [todoCategory, beaconCategory, geoCategory, reminderCategory]) as? Set<UIUserNotificationCategory>))
    }
    
    func registerGCM(){
        
        // [START_EXCLUDE]
        // Configure the Google context: parses the GoogleService-Info.plist, and initializes
        // the services that have entries in the file
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        // [END_EXCLUDE]
        
        // [START start_gcm_service]
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = self
        GCMService.sharedInstance().startWithConfig(gcmConfig)
        // [END start_gcm_service]
        
    }
    
    func getGCMToken(deviceToken:NSData){
        
        // [START get_gcm_reg_token]
        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
            kGGLInstanceIDAPNSServerTypeSandboxOption:false]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
        // [END get_gcm_reg_token]

        GCMService.sharedInstance().connectWithHandler({
            (error) -> Void in
            if error != nil {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
            }
        })
    }

    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            defaults.setValue(registrationToken, forKey: "token")
            InitialLoadManager.sharedInstance.load()
            //self.subscribeToTopic()
            //let userInfo = ["registrationToken": registrationToken]
            //NotificationCenter.default.post(name: 
            //self.registrationKey, object: nil, userInfo: userInfo)
        } else {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            //let userInfo = ["error": error.localizedDescription]
            //NotificationCenter.default.post(name: 
            //self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    
    // [START on_token_refresh]

    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    // [END on_token_refresh]
    
    // [START upstream_callbacks]
    func willSendDataMessageWithID(messageID: String!, error: NSError!) {
        if (error != nil) {
            // Failed to send the message.
        } else {
            // Will send message, you can save the messageID to track the message
        }
    }
    
    func didSendDataMessageWithID(messageID: String!) {
        // Did successfully send message identified by messageID
    }
    // [END upstream_callbacks]

    func didDeleteMessagesOnServer() {
        // Some messages sent to this device were deleted on the GCM server before reception, likely
        // because the TTL expired. The client should notify the app server of this, so that the app
        // server can resend those messages.
    }

}
