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
    var region = CLBeaconRegion()
    
    var major : CLBeaconMajorValue = 2793
    var minor : CLBeaconMinorValue = 19481
    var identifier = "time left"
    func startRanging(){
        
        beaconManager = ESTBeaconManager()
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        region = CLBeaconRegion(proximityUUID: virtual_uuid!, major: major, minor: minor, identifier: identifier)//purple
        
        beaconManager.startMonitoringForRegion(region)
        //beaconManager.startRangingBeaconsInRegion(region)
        
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
        print(region)
        
        let notification = UILocalNotification()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "Firefly"
        } else {
            // Fallback on earlier versions
        }
        
        notification.alertBody = "Welcome to Subang Airport"
        notification.soundName = UILocalNotificationDefaultSoundName
        //notification.applicationIconBadgeNumber = 1
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        
    }
    
    func showMessage(){
        SCLAlertView().showSuccess("Welcome", subTitle: region.identifier, closeButtonTitle: "Close", colorStyle:0xEC581A)
    }
    
    func beaconManager(manager: AnyObject, didExitRegion region: CLBeaconRegion) {
        print(region)
    }
    
    
    
}
