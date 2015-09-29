//
//  Functions.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 9/25/15.
//  Copyright (c) 2015 Aashir. All rights reserved.
//

import UIKit

class Functions: NSObject {
   
    // Convert UIView to UIImage
    /* Repurposed from OBJ Code at http://stackoverflow.com/questions/4334233/how-to-capture-uiview-to-uiimage-without-loss-of-quality-on-retina-display */
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    class func getBuildings( completion: (( success: Bool?, buildings: [AnyObject]? ) -> Void )) {
        var query = PFQuery(className: "Map_Buildings")
        query.whereKey("disabled", notEqualTo: true)
        query.findObjectsInBackgroundWithBlock { (buildings, error) -> Void in
            if error != nil {
                println("F:", error!.description)
                completion(success: false, buildings: [AnyObject]())
            } else {
                completion(success: true, buildings: buildings)
            }
        }
    }
    
    /*
    class func shouldUpdateBuildings() -> (Bool) {
        var fiveDaysAgo = NSDate().dateByAddingTimeInterval(-86400 * 2)
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var lastDate: AnyObject? = defaults.objectForKey("lastUpdateDate")
        if (lastDate == nil) {
            defaults.setObject(NSDate(), forKey: "lastUpdateDate")
            return true
        } else if ( fiveDaysAgo.compare(lastDate as! NSDate) == NSComparisonResult.OrderedDescending)  {
            // fiveDaysAgo is later than lastDate
            defaults.setObject(NSDate(), forKey: "lastUpdateDate")
            return true
        } else {
            return false
        }
        
    }*/

    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rString = (cString as NSString).substringToIndex(2)
        var gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        var bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
