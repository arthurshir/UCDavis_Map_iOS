//
//  Buildings.swift
//  
//
//  Created by Arthur Shir on 10/11/15.
//
//

import Foundation
import CoreData
@objc(Buildings)

class Buildings: NSManagedObject {

    @NSManaged var lat: NSNumber
    @NSManaged var lng: NSNumber
    @NSManaged var name: String
    @NSManaged var link: String

}
