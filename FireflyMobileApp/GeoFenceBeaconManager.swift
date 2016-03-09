//
//  GeoFenceBeaconManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/9/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import CoreLocation

class GeoFenceBeaconManager: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = GeoFenceBeaconManager()
    
    let locationManager = CLLocationManager()
    var newBeacon: Beacon?
    
    func startGeoFence(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
    }
    
    func startBeacon(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        let uuid = virtual_uuid
        let major: CLBeaconMajorValue = UInt16(7714)
        let minor: CLBeaconMinorValue = UInt16(13156)
        
        newBeacon = Beacon(name: "test", uuid: uuid!, majorValue: major, minorValue: minor)
        startMonitoringItem(newBeacon!)
        
    }
    
    func beaconRegionWithItem(beacon:Beacon) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(proximityUUID: beacon.uuid, major: beacon.majorValue, minor: beacon.minorValue, identifier: beacon.name)
        return beaconRegion
    }
    
    func startMonitoringItem(beacon:Beacon) {
        let beaconRegion = beaconRegionWithItem(beacon)
        locationManager.startMonitoringForRegion(beaconRegion)
        //locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func stopMonitoringItem(beacon:Beacon) {
        let beaconRegion = beaconRegionWithItem(beacon)
        locationManager.stopMonitoringForRegion(beaconRegion)
        //locationManager.stopRangingBeaconsInRegion(beaconRegion)
    }
    
}
