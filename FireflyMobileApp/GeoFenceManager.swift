//
//  GeoFenceManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/9/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import CoreLocation

class GeoFenceManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = GeoFenceManager()
    
    let locationManager = CLLocationManager()
    
    func startGeoFence(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                locationManager.stopMonitoringForRegion(circularRegion)
            }
        }
        let geoLocation = getGeotification()
        startMonitoringGeotification(geoLocation)
        
    }

    func getGeotification() -> Geotification{
        
        let lat = "3.0825501"//2.9238587"//
        let lon = "101.4863185"//101.655948"//
        let radiuss = "500"
        
        let coordinate = CLLocationCoordinate2D(
            latitude: (lat as NSString).doubleValue as CLLocationDegrees,
            longitude: (lon as NSString).doubleValue as CLLocationDegrees
        )
        
        let radius = (radiuss as NSString).doubleValue
        let identifier = "airport"
        
        let clampedRadius = (radius > locationManager.maximumRegionMonitoringDistance) ? locationManager.maximumRegionMonitoringDistance : radius
        
        let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier)
        
        return geotification
        
    }
    
    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        return region
    }
    
    func startMonitoringGeotification(geotification: Geotification) {
        let region = regionWithGeotification(geotification)
        locationManager.startMonitoringForRegion(region)
    }
    
    func stopMonitoringGeotification(geotification: Geotification) {
        let region = regionWithGeotification(geotification)
        locationManager.stopMonitoringForRegion(region)
    }

}
