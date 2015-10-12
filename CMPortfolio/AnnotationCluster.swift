//
//  AnnotationCluster.swift
//  
//
//  Created by Arthur Shir on 10/11/15.
//
//

import UIKit

class AnnotationCluster: NSObject {
    var coordinate = CLLocationCoordinate2D()
    var title = String()
    var subtitle = String()
    var annotations = [AnyObject]()
}
