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
    var firstCheck = Bool()
    
    func checkBluetooth(){
        let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        if !firstCheck{

            if peripheral.state == CBPeripheralManagerState.PoweredOff{
                bluetoothState("PoweredOff")
            }else if peripheral.state == CBPeripheralManagerState.PoweredOn{
                bluetoothState("PoweredOn")
            }
            
        }
        
    }
    
    func bluetoothState(state : String){
        
        let notification = UILocalNotification()
        var turnOn = Bool()
        
        var msg = "Firefly welcomes "
        
        if try! LoginManager.sharedInstance.isLogin(){
            let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
            msg += "\(getTitleName(userInfo["title"] as! String)) \(userInfo["first_name"] as! String) to Subang Airport. "
        }else{
            msg += "Guest to Subang Airport. "
        }
        
        
        if state == "PoweredOn"{
            
            msg += "This app requires Bluetooth connection. Please switch on your Bluetooth."
            notification.alertBody = msg
            notification.userInfo = NSDictionary(object: "TurnOnBluetooth", forKey: "identifier") as [NSObject : AnyObject]
            turnOn = true
            firstCheck = true

        }else if state == "PoweredOff"{
            
            notification.alertBody = msg
            firstCheck = true
            
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
        
        var msg = "Firefly welcomes "
        if try! LoginManager.sharedInstance.isLogin(){
            let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
            msg += "\(getTitleName(userInfo["title"] as! String)) \(userInfo["first_name"] as! String) "
        }else{
            msg += "Guest "
        }
        
        msg += "to Subang Airport. This app requires Bluetooth connection. Please switch on your Bluetooth."
        
        let alert = SCLAlertView()
        alert.addButton("Open Setting", target: self, selector: "openSetting")
        alert.showSuccess("Welcome", subTitle: msg, colorStyle:0xEC581A, closeButtonTitle : "Close")
        
    }
    
    func openSetting(){
        UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=Bluetooth")!)
    }
    
}
