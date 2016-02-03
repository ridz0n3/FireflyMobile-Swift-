//
//  BluetoothManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/2/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView

class BluetoothManager: NSObject, CBPeripheralManagerDelegate {
    
    static let sharedInstance = BluetoothManager()
    var bluetoothPeripheralManager: CBPeripheralManager?
    var checkState = Bool()
    var checkresult = Bool()
    
    func checkBluetooth(){
        checkState = false
        let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
    
    func checkBluetoothState(){
        checkState = true
        let options = [CBCentralManagerOptionShowPowerAlertKey:0] //<-this is the magic bit!
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
        
        //return checkresult
        
    }
    
    //MARK: bluetooth delegate
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        if peripheral.state == CBPeripheralManagerState.PoweredOff {
            showTurnOn()
        }else if peripheral.state == CBPeripheralManagerState.PoweredOn{
            BeaconManager.sharedInstance.startMonitor(2793, minor: 19481, identifier: "checkingate", uuid : virtual_uuid!)
            //BeaconManager.sharedInstance.startMonitor(17407, minor: 28559, identifier: "checkingate", uuid : estimote_uuid!)
            startScan()
        }
        
    }
    
    func showTurnOn(){
        
        let userInfo = defaults.objectForKey("userInfo")
        
        let alert = SCLAlertView()
        alert.addButton("Open Setting", target: self, selector: "openSetting")
        alert.showSuccess("Welcome", subTitle: "Firefly welcomes \(userInfo!["title"]! as! String) \(userInfo!["first_name"] as! String) to Subang Airport. This app requires Bluetooth connection. Click OK to switch on Bluetooth.", colorStyle:0xEC581A, closeButtonTitle : "Close")
        
    }
    
    func startScan(){
        
        let alert = SCLAlertView()
        alert.showSuccess("Yeay!!", subTitle: "You will be notified soon", colorStyle:0xEC581A, closeButtonTitle : "Close")
    }
    
    func openSetting(){
        UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=Bluetooth")!)
    }
    
}
