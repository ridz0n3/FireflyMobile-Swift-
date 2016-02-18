//
//  BeaconManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/11/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON

class BeaconManager: NSObject, ESTBeaconManagerDelegate {
    
    static let sharedInstance = BeaconManager()
    
    var beaconManager = ESTBeaconManager()
    var regions = CLBeaconRegion()
    
    func startMonitor(major : CLBeaconMajorValue, minor : CLBeaconMinorValue, identifier : String, uuid : NSUUID){
        beaconManager = ESTBeaconManager()
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        regions = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        
        regions.notifyOnEntry = true
        regions.notifyOnExit = true
        beaconManager.startMonitoringForRegion(regions)
        //beaconManager.stopMonitoringForRegion(regions)
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print(beacons)
    }
    
    func beaconManager(manager: AnyObject, rangingBeaconsDidFailForRegion region: CLBeaconRegion?, withError error: NSError) {
        print(error.localizedDescription)
    }
    
    func beaconManager(manager: AnyObject, didStartMonitoringForRegion region: CLBeaconRegion) {
        print(beaconManager.monitoredRegions)
    }
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        
        if UIApplication.sharedApplication().applicationState == .Active{
            
            if region.identifier == "checkingate"{
                checkStatus()
            }else if region.identifier == "Departure"{
                
                departureMessage()
                
                for notification in UIApplication.sharedApplication().scheduledLocalNotifications! { // loop through notifications...
                    if (notification.userInfo!["identifier"] as! String == "time out") {
                        UIApplication.sharedApplication().cancelLocalNotification(notification) 
                        break
                    }
                }
                
            }
            
        }else{
            
            var msg = String()
            if region.identifier == "Departure"{
                msg = "Have a save journey"
                
                for notifications in UIApplication.sharedApplication().scheduledLocalNotifications! { // loop through notifications...
                    if (notifications.userInfo!["identifier"] as! String == "time out") {
                        UIApplication.sharedApplication().cancelLocalNotification(notifications)
                        break
                    }
                }
                
            }else if region.identifier == "checkingate"{
                msg = "Your flight information is as displayed. You may print boarding pass at Firefly kiosk."
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
        beaconManager.stopMonitoringForRegion(region)
        
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
        //showTimeOut("region exit")
    }
    
    func doneBtnPressed(){
        exit(0)
    }
    
    func departure(sender:NSNotificationCenter){
        regions = CLBeaconRegion(proximityUUID: estimote_uuid!, major: 24330, minor: 2117, identifier: "Departure")//purple
        
        beaconManager.startMonitoringForRegion(regions)//.startRangingBeaconsInRegion(regions)//
    }
    
    
    func checkStatus(){
        
        let userinfo = defaults.objectForKey("userInfo")
        
        showHud("open")
        //userinfo!["username"] as! String, userinfo!["password"] as! String
        //"zhariffadam@me-tech.com.my","ubYXnfrZhQs4X7ZJ9y4rwQ=="
        
        FireFlyProvider.request(.RetrieveBookingList(userinfo!["username"] as! String, userinfo!["password"] as! String, "beacon")) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    showHud("close")
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        if json["list_booking"].count != 0{
                            let storyboard = UIStoryboard(name: "Beacon", bundle: nil)
                            let sendItineraryVC = storyboard.instantiateViewControllerWithIdentifier("BeaconQRCodeVC") as! BeaconQRCodeViewController
                            sendItineraryVC.data = json.object as! NSDictionary
                            let appDelegate = UIApplication.sharedApplication().keyWindow?.rootViewController
                            appDelegate!.presentViewController(sendItineraryVC, animated: true, completion: nil)
                        }else if json["status"] == "error"{
                            self.showTimeOut("No Flight Today")
                        }
                        
                    }else{
                    }
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                print (failureResult)
            }
        }
        
    }

}
