//
//  BeaconManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/9/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = BeaconManager()
    
    let locationManager = CLLocationManager()
    var newBeacon: Beacon?
    
    func startBeacon(identifier : String, uuid : NSUUID,  major: CLBeaconMajorValue, minor: CLBeaconMinorValue){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        newBeacon = Beacon(name: identifier, uuid: uuid, majorValue: major, minorValue: minor)
        startMonitoringItem(newBeacon!)
        
    }
    
    func beaconRegionWithItem(beacon:Beacon) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(proximityUUID: beacon.uuid, major: beacon.majorValue, minor: beacon.minorValue, identifier: beacon.name)
        return beaconRegion
    }
    
    func startMonitoringItem(beacon:Beacon) {
        let beaconRegion = beaconRegionWithItem(beacon)
        locationManager.startMonitoringForRegion(beaconRegion)
    }
    
    func stopMonitoringItem(beacon:Beacon) {
        let beaconRegion = beaconRegionWithItem(beacon)
        locationManager.stopMonitoringForRegion(beaconRegion)
    }
}
