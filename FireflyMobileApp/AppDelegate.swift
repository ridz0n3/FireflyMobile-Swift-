//
//  AppDelegate.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import MFSideMenu
import XLForm
import RealmSwift
import Realm
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let baseView = BaseViewController()
    let locationManager = CLLocationManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        locationManager.delegate = self
        
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeledTextField] = FloatLabeledTextFieldCell.self
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeledPicker] = FloatLabeledPickerCell.self
        XLFormViewController.cellClassesForRowDescriptorTypes()[XLFormRowDescriptorTypeFloatLabeledDatePicker] = FloateLabeledDatePickerCell.self
        
        InitialLoadManager.sharedInstance.load()
        UINavigationBar.appearance().barTintColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().translucent = false
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let container = storyboard.instantiateViewControllerWithIdentifier("MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        
        self.window?.rootViewController = container
        
        let sideMenuVC = storyboard.instantiateViewControllerWithIdentifier("sideMenuVC") as! SideMenuTableViewController
        
        let homeStoryBoard = UIStoryboard(name: "Home", bundle: nil)
        let navigationController = homeStoryBoard.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
        
        container.leftMenuViewController = sideMenuVC
        container.centerViewController = navigationController
        
        container.leftMenuWidth = UIScreen.mainScreen().applicationFrame.size.width - 100
        
        let config = RLMRealmConfiguration.defaultConfiguration()
        config.schemaVersion = 8
        config.migrationBlock = { (migration, oldSchemaVersion) in
            // nothing to do
        }
        RLMRealmConfiguration.setDefaultConfiguration(config)
        GeoFenceManager.sharedInstance.startGeoFence()
        BluetoothManager.sharedInstance.checkBluetooth()
        return true
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
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        if let identifier = notification.userInfo{
            
            if identifier["identifier"] as! String == "test"{
                print("masuk")
            }else if identifier["identifier"] as! String == "TurnOnBluetooth"{
                BluetoothManager.sharedInstance.showTurnOn()
            }
            
        }
        
    }
}

// MARK: CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        if let _ = region as? CLBeaconRegion {
            let notification = UILocalNotification()
            notification.alertBody = "Exit Beacon?"
            notification.soundName = "Default"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        
        if let _ = region as? CLCircularRegion{
            let notification = UILocalNotification()
            notification.alertBody = "Exit Geotification"
            notification.soundName = "Default"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if let beaconRegion = region as? CLBeaconRegion {
            
            let major = Int(beaconRegion.major!)
            let minor = Int(beaconRegion.minor!)
            BeaconManager.sharedInstance.stopBeacon(beaconRegion.identifier, major: UInt16(major), minor: UInt16(minor))
            
            let notification = UILocalNotification()
            notification.userInfo = NSDictionary(object: beaconRegion.identifier, forKey: "identifier") as [NSObject : AnyObject]
            notification.alertBody = "Enter Beacon"
            notification.soundName = "Default"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            
        }
        
        if let _ = region as? CLCircularRegion{
            
            BluetoothManager.sharedInstance.checkBluetooth()
            BeaconManager.sharedInstance.startBeacon("test", major: UInt16(2793), minor: UInt16(19481))
            //BeaconManager.sharedInstance.startBeacon("test", major: UInt16(7714), minor: UInt16(13156))
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print(region)
    }
}

