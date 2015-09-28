//
//  BuildingObject.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 9/27/15.
//  Copyright (c) 2015 Aashir. All rights reserved.
//

import UIKit
import MapKit

class BuildingObject: NSObject {
    var name : String?
    var coords : CLLocationCoordinate2D?
    
    class func makeBuilding(name: String, coords: CLLocationCoordinate2D) -> BuildingObject {
        var bo = BuildingObject()
        bo.name = name
        bo.coords = coords
        return bo
    }
}
