//
//  GeoFenceBeaconManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/9/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import CoreLocation

class GeoFenceBeaconManager: NSObject {

    let locationManager = CLLocationManager()
    
    func startGeoFence(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startBeacon(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    
    
}
