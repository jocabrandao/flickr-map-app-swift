//
//  DroppablePin.swift
//  flickr-map-ios
//
//  Created by João Carlos Brandão on 07/09/17.
//  Copyright © 2017 BWmobi. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
    
}
