//
//  Geotification.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/9/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let kGeotificationLatitudeKey = "latitude"
let kGeotificationLongitudeKey = "longitude"
let kGeotificationRadiusKey = "radius"
let kGeotificationIdentifierKey = "identifier"

class Geotification: NSObject, NSCoding, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
    }
    
    // MARK: NSCoding
    
    required init?(coder decoder: NSCoder) {
        let latitude = decoder.decodeDoubleForKey(kGeotificationLatitudeKey)
        let longitude = decoder.decodeDoubleForKey(kGeotificationLongitudeKey)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDoubleForKey(kGeotificationRadiusKey)
        identifier = decoder.decodeObjectForKey(kGeotificationIdentifierKey) as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeDouble(coordinate.latitude, forKey: kGeotificationLatitudeKey)
        coder.encodeDouble(coordinate.longitude, forKey: kGeotificationLongitudeKey)
        coder.encodeDouble(radius, forKey: kGeotificationRadiusKey)
        coder.encodeObject(identifier, forKey: kGeotificationIdentifierKey)
    }
}
