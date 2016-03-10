//
//  BluetoothManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/2/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreBluetooth

class BluetoothManager: NSObject, CBPeripheralManagerDelegate {
    
    static let sharedInstance = BluetoothManager()
    var bluetoothPeripheralManager: CBPeripheralManager?
    var userInfo = [NSObject : AnyObject]()
    
    func checkBluetooth(){
        let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
    
    func checkBluetoothState(){
        let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        let notification = UILocalNotification()
        var turnOn = Bool()
        
        if peripheral.state == CBPeripheralManagerState.PoweredOff{
            notification.alertBody = "Firefly welcomes to Subang Airport. This app requires Bluetooth connection. Please switch on your Bluetooth."
            notification.userInfo = NSDictionary(object: "TurnOnBluetooth", forKey: "identifier") as [NSObject : AnyObject]
            turnOn = true
        }else if peripheral.state == CBPeripheralManagerState.PoweredOn{
            notification.alertBody = "Firefly welcomes to Subang Airport."
        }
        
        
        notification.soundName = "Default"
    
        if UIApplication.sharedApplication().applicationState == .Active{
            if turnOn{
                showTurnOn()
            }
        }else{
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        
        
    }
    
    func showTurnOn(){
        
        //let userInfo = defaults.objectForKey("userInfo")
        
        let alert = SCLAlertView()
        alert.addButton("Open Setting", target: self, selector: "openSetting")
        alert.showSuccess("Welcome", subTitle: "Firefly welcomes to Subang Airport. This app requires Bluetooth connection. Click OK to switch on Bluetooth.", colorStyle:0xEC581A, closeButtonTitle : "Close")
        
    }
    
    func openSetting(){
        UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=Bluetooth")!)
    }
    
}
