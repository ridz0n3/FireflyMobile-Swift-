//
//  GeoFenceManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/22/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView

class GeoFenceManager: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = GeoFenceManager()
    let locationManager = CLLocationManager()
    
    func startGeoFence(){
        
        // 1
        locationManager.delegate = self
        // 2
        locationManager.requestAlwaysAuthorization()
        startMonitoringGeotification(getGeotification())
    }
    
    func getGeotification() -> Geotification{
        
        let lat = "2.9238587"
        //let lon = "101.486798453622"
        let lon = "101.655948"
        let radiuss = "500"
        
        let coordinate = CLLocationCoordinate2D(
            latitude: (lat as NSString).doubleValue as CLLocationDegrees,
            longitude: (lon as NSString).doubleValue as CLLocationDegrees
        )
        
        let radius = (radiuss as NSString).doubleValue
        let identifier = "klia"
        let note = "Welcome"
        let eventType = EventType.OnEntry
        
        // 1
        let clampedRadius = (radius > locationManager.maximumRegionMonitoringDistance) ? locationManager.maximumRegionMonitoringDistance : radius
        
        let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
        
        return geotification
        
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print(region)
    }
    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = true
        //region.notifyOnExit = true//!region.notifyOnEntry
        return region
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let notification = UILocalNotification()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "Firefly"
        } else {
            // Fallback on earlier versions
        }
        let userInfo = defaults.objectForKey("userInfo")
        notification.userInfo = ["identifier" : "geofence"]
        notification.alertBody = "Firefly welcomes \(userInfo!["title"]! as! String) \(userInfo!["first_name"] as! String) to Subang Airport. This app requires Bluetooth connection. Click OK to switch on Bluetooth."
        //notification.category = "Check_Bluetooth"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        //stopMonitoringGeotification(getGeotification())
        
    }
    
    /*func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        let notification = UILocalNotification()
        if #available(iOS 8.2, *) {
            notification.alertTitle = "Firefly"
        } else {
            // Fallback on earlier versions
        }
        
        //notification.category = "TODO_CATEGORY"
        notification.userInfo = ["identifier" : "exit"]
        notification.alertBody = "Good Bye, Have a save journey"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        
    }*/
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
        
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                //if circularRegion.identifier == geotification.identifier {
                    locationManager.stopMonitoringForRegion(circularRegion)
               // }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    func stopMonitoringGeotification(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == geotification.identifier {
                    locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }
    
    func startMonitoringGeotification(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            
            //SCLAlertView().showSuccess("Error", subTitle: "Geofencing is not supported on this device!", colorStyle:0xEC581A, closeButtonTitle:"Close")
            
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            //SCLAlertView().showSuccess("Warning", subTitle: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", colorStyle:0xEC581A, closeButtonTitle:"Close")
        }
        // 3
        let region = regionWithGeotification(geotification)
        // 4
        locationManager.startMonitoringForRegion(region)
        //locationManager.stopMonitoringForRegion(region)
    }
    
}
