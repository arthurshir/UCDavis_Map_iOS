//
//  QuadTreeNode.swift
//  
//
//  Created by Arthur Shir on 10/11/15.
//
//

var kNodeCapacity = 8

import UIKit
import GoogleMaps

class QuadTreeNode: NSObject {

    struct BoundingBox {
        var x0: CGFloat
        var y0: CGFloat
        var xf: CGFloat
        var yf: CGFloat
    }
    
    
    var count = 0
    var boundingBox: BoundingBox?
    var markers = [AnyObject]()
    
    var northEast : QuadTreeNode?
    var northWest : QuadTreeNode?
    var southEast : QuadTreeNode?
    var southWest : QuadTreeNode?
    
    override init() {
        super.init()
        self.count = 0
        self.northEast = nil
        self.northWest = nil
        self.southEast = nil
        self.southWest = nil
    }

    class func initWithBoundingBox(box: BoundingBox) -> QuadTreeNode {
        var node = QuadTreeNode()
        node.boundingBox = box
        return node
    }
    
    func isLeaf() -> Bool {
        // Node is a leaf if it isn't subdivided (any Node.node == nil)
        return (self.northEast == nil)
    }
    
    func subdivide() {
        // Set up Four Quadrants
        self.northEast = QuadTreeNode()
        self.northWest = QuadTreeNode()
        self.southEast = QuadTreeNode()
        self.southWest = QuadTreeNode()
        
        // Get Middle Lines
        var box = self.boundingBox!
        var xMid = (box.xf + box.x0) / 2.0
        var yMid = (box.yf + box.y0) / 2.0
        
        // Set Boxes for each Quadrant
        self.northEast!.boundingBox = BoundingBox(x0: xMid, y0: box.y0, xf: box.xf, yf: yMid)
        self.northWest!.boundingBox = BoundingBox(x0: box.x0, y0: box.y0, xf: xMid, yf: yMid)
        self.southEast!.boundingBox = BoundingBox(x0: xMid, y0: yMid, xf: box.xf, yf: box.yf)
        self.southWest!.boundingBox = BoundingBox(x0: box.x0, y0: yMid, xf: xMid, yf: box.yf)
    }

    
    func boundingBoxForMapRect(northEast: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D) -> BoundingBox {
        
        var minLat = northEast.latitude
        var maxLat = southWest.latitude
        
        var minLon = southWest.longitude
        var maxLon = northEast.longitude
        
        return BoundingBox(x0: CGFloat(minLat), y0: CGFloat(minLon), xf: CGFloat(maxLat), yf: CGFloat(maxLon) )
        
    }
    
    
    /*
    func init(box: BoundingBox){
        self = self.init()
        if (self != nil) {
            self.boundingBox = box
        }
        var node = QuadTreeNode()
        node.boundingBox = box
        return node
    }*/
    
    
    
}
