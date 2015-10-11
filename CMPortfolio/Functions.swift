//
//  Functions.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 9/25/15.
//  Copyright (c) 2015 Aashir. All rights reserved.
//

import UIKit
import CoreData

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
    
    class func getDavisBuildings( completion: (( success: Bool?, buildings: [AnyObject] ) -> Void )) {
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "f47aa33c-cf0a-df34-594d-aa7eceb57ead"
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://mobile.ucdavis.edu/locations/")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(success: false, buildings: [AnyObject]())
                println(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                var arr = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers , error: nil) as! NSMutableArray
                
                // Delete Old Buildings
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                let fetchRequest = NSFetchRequest(entityName: "Buildings")
                fetchRequest.includesPropertyValues = false
                let buil = managedContext?.executeFetchRequest(fetchRequest, error: nil)
                if (buil != nil) {
                    if buil!.count > 0 {
                        for b in buil! {
                            managedContext?.deleteObject(b as! NSManagedObject)
                        }
                    }
                }

                // Save New Buildings
                var dic = arr.objectAtIndex(arr.count-1) as! NSDictionary
                var buildings = dic.objectForKey("locations") as! [NSDictionary]
                for b in buildings {
                    println(b)
                    var lat = b.objectForKey("lat") as? String
                    var lng = b.objectForKey("lng") as? String
                    var name = b.objectForKey("name") as? String
                    var link = b.objectForKey("link") as? String
                    if (lat == nil || lng == nil || name == nil || link == nil) {
                        println("F: Error retrieving building components")
                    } else {
                        var latDouble = NSString(string: lat!).doubleValue
                        var lngDouble = NSString(string: lng!).doubleValue
                        Functions.saveBuilding(latDouble, lng: lngDouble, name: name!, link: link!)
                    }
                }
                
                //println(dic.objectForKey("name") )
                
                completion(success: true, buildings: dic.objectForKey("locations") as! [AnyObject] )
            }
        })
        
        dataTask.resume()
    }
    
    class func saveBuilding(lat: NSNumber, lng: NSNumber, name: String, link: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        
        var building = NSEntityDescription.insertNewObjectForEntityForName("Buildings", inManagedObjectContext: managedContext!) as! Buildings
        
        building.lat = lat
        building.lng = lng
        building.name = name
        building.link = link
        
        //3
        managedContext!.save(nil)
        
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

    class func makeFrame(x: Int, y: Int, width: Int, height: Int) -> CGRect {
        return CGRectMake( CGFloat(x), CGFloat(y), CGFloat(width), CGFloat(height) )
    }
    
    class func themeColor() -> UIColor {
        return colorWithHexString("1E466B")
    }

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
