//
//  BeaconManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/11/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView

class BeaconManager: NSObject, ESTBeaconManagerDelegate {
    
    static let sharedInstance = BeaconManager()
    
    var beaconManager = ESTBeaconManager()
    var regions = CLBeaconRegion()
    var major : CLBeaconMajorValue = 2820
    var minor : CLBeaconMinorValue = 40462
    var identifier = "time left"
     
    
    func startRanging(){
        
        beaconManager = ESTBeaconManager()
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        regions = CLBeaconRegion(proximityUUID: estimote_uuid!, major: major, minor: minor, identifier: identifier)//purple
        
        beaconManager.startMonitoringForRegion(regions)
        //beaconManager.startRangingBeaconsInRegion(region)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "departure:", name: "refreshDeparture", object: nil)
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print(beacons)
    }
    
    func beaconManager(manager: AnyObject, rangingBeaconsDidFailForRegion region: CLBeaconRegion?, withError error: NSError) {
        print(error.localizedDescription)
    }
    
    func beaconManager(manager: AnyObject, didStartMonitoringForRegion region: CLBeaconRegion) {
        print(region)
    }
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        
        beaconManager.stopMonitoringForRegion(region)
        
        if UIApplication.sharedApplication().applicationState == .Active{
            
            if region.identifier == "time left"{
                showMessage()
            }else if region.identifier == "Departure"{
                
                departureMessage()
                
                for notification in UIApplication.sharedApplication().scheduledLocalNotifications! { // loop through notifications...
                    if (notification.userInfo!["identifier"] as! String == "time out") { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                        UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                        break
                    }
                }
                
            }else{
                arriveAtCheckInCounter()
            }
            
        }else{
            
            var msg = String()
            if region.identifier == "time left"{
                msg = "Welcome to Subang Airport"
            }else if region.identifier == "Departure"{
                msg = "Have a save journey"
            }else{
                msg = "You're now at check in region"
            }
            
            let notification = UILocalNotification()
            if #available(iOS 8.2, *) {
                notification.alertTitle = "Firefly"
            } else {
                // Fallback on earlier versions
            }
            
            notification.userInfo = ["identifier" : region.identifier]
            notification.alertBody = msg
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        
    }
    
    func arriveAtCheckInCounter(){
        
        let storyboard = UIStoryboard(name: "Beacon", bundle: nil)
        let sendItineraryVC = storyboard.instantiateViewControllerWithIdentifier("BeaconCheckInVC") as! BeaconCheckInViewController
        let appDelegate = UIApplication.sharedApplication().keyWindow?.rootViewController
        appDelegate!.presentViewController(sendItineraryVC, animated: true, completion: nil)
        
        let date = NSDate()
        let addtime = date.dateByAddingTimeInterval(1.0 * 60.0)
        
        let notification = UILocalNotification()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "Firefly"
        } else {
            // Fallback on earlier versions
        }
            
        notification.userInfo = ["identifier" : "time out", "msg" : "Your flight will depart in 10minutes more, please hurry"]
        notification.alertBody = "Hurry"
        notification.fireDate = addtime
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
    }
    
    func showTimeOut(sender:String){
        
        let alert = SCLAlertView()
        alert.showSuccess("Alert", subTitle: sender, colorStyle:0xEC581A, closeButtonTitle:"Close")
        
    }
    
    var clock = NSTimer()
    func showMessage(){

        let alert = SCLAlertView()
        alert.addButton("Okay!", target: self, selector: "doneBtnPressed")
        alert.showCloseButton = false
        alert.showSuccess("Welcome", subTitle: "Your flight departure time left 30 minutes more", colorStyle:0xEC581A)

    }
    
    func departureMessage(){
        
        let alert = SCLAlertView()
        alert.showSuccess("Good Bye!", subTitle: "Have a save journey", colorStyle:0xEC581A)
        
    }
    
    func beaconManager(manager: AnyObject, didExitRegion region: CLBeaconRegion) {
        print(region)
    }
    
    func doneBtnPressed(){
        
        regions = CLBeaconRegion(proximityUUID: estimote_uuid!, major: 17407, minor: 28559, identifier: "Checkin Counter")//purple
        
        beaconManager.startMonitoringForRegion(regions)
        
    }
    
    func departure(sender:NSNotificationCenter){
        regions = CLBeaconRegion(proximityUUID: estimote_uuid!, major: 24330, minor: 2117, identifier: "Departure")//purple
        
        beaconManager.startMonitoringForRegion(regions)
    }

}
