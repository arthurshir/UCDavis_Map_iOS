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
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    class func getBuildings( completion: (( success: Bool?, buildings: [AnyObject]? ) -> Void )) {
        let query = PFQuery(className: "Map_Buildings")
        query.whereKey("disabled", notEqualTo: true)
        query.findObjectsInBackgroundWithBlock { (buildings, error) -> Void in
            if error != nil {
                print("F:", error!.description)
                completion(success: false, buildings: [AnyObject]())
            } else {
                completion(success: true, buildings: buildings)
            }
        }
    }
    
    class func getDavisBuildings( completion: (( success: Bool?, buildings: [AnyObject] ) -> Void )) {
        
        // Disclaimer: Code is generated from PostMan
        
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "f47aa33c-cf0a-df34-594d-aa7eceb57ead"
        ]
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://mobile.ucdavis.edu/locations/")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(success: false, buildings: [AnyObject]())
                print(error)
            } else {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(data!, forKey: "BuildingsData")
                //let arr = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! NSMutableArray
                
                completion(success: true, buildings: [AnyObject]() )
            }
        })
        
        dataTask.resume()
    }
    
    // Retrieve Arrays from Saved JSON Data
    class func returnArray(category: Int) -> [AnyObject] {
        
        // Return Array for Favorites
        if (category == 5) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            var ret = [AnyObject]()
            let request = NSFetchRequest(entityName: "Buildings")
            let buil = try? managedContext!.executeFetchRequest(request)
            if ( buil != nil) {
                for b in buil! {
                    let b = b as! Buildings
                    let locObj = LocationObj()
                    locObj.lng = Double(b.lng)
                    locObj.lat = Double(b.lat)
                    locObj.name = b.name
                    locObj.link = b.link
                    ret.append(locObj)
                }
                return ret
            } else {
                return [AnyObject]()
            }
        }
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = defaults.objectForKey("BuildingsData") as? NSData
        if data == nil { return [AnyObject]() }
        
        let arr = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! NSMutableArray
        
        var ret = [AnyObject]()
        
        let dic = arr.objectAtIndex(arr.count - 1 - category) as! NSDictionary
        let buildings = dic.objectForKey("locations") as! [NSDictionary]
        for b in buildings {
            //print(b)
            let lat = b.objectForKey("lat") as? String
            let lng = b.objectForKey("lng") as? String
            let name = b.objectForKey("name") as? String
            let link = b.objectForKey("link") as? String
            if (lat == nil || lng == nil || name == nil || link == nil) {
                print("F: Error retrieving building components")
            } else {
                // Save Each Building as a "Buildings" Object
                let latDouble = NSString(string: lat!).doubleValue
                let lngDouble = NSString(string: lng!).doubleValue
                let b = LocationObj()
                b.lat = latDouble
                b.lng = lngDouble
                b.name = name!
                b.link = link!
                ret.append(b)
            }
        }
        
        
        return ret
        
        /*
        // Save New Buildlets
        let dic = arr.objectAtIndex(arr.count-1) as! NSDictionary
        let buildings = dic.objectForKey("locations") as! [NSDictionary]
        for b in buildings {
            print(b)
            let lat = b.objectForKey("lat") as? String
            let lng = b.objectForKey("lng") as? String
            let name = b.objectForKey("name") as? String
            let link = b.objectForKey("link") as? String
            if (lat == nil || lng == nil || name == nil || link == nil) {
                print("F: Error retrieving building components")
            } else {
                let latDouble = NSString(string: lat!).doubleValue
                let lngDouble = NSString(string: lng!).doubleValue
                Functions.saveBuilding(latDouble, lng: lngDouble, name: name!, link: link!)
            }
        }
        */
    }
    
    class func returnCategoryName(catIndex: Int) -> String {
        
        // Return Name for Favorites
        if (catIndex == 5) {
            return "Favorites"
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = defaults.objectForKey("BuildingsData") as? NSData
        if data == nil { return "" }
        
        let arr = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers )) as! NSMutableArray
        
        var ret = [AnyObject]()
        
        let dic = arr.objectAtIndex(arr.count - 1 - catIndex) as! NSDictionary
        let name = dic.objectForKey("name") as! String
        return name
        
    }
    
    
    class func saveBuilding(lat: NSNumber, lng: NSNumber, name: String, link: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        
        let building = NSEntityDescription.insertNewObjectForEntityForName("Buildings", inManagedObjectContext: managedContext!) as! Buildings
        
        building.lat = lat
        building.lng = lng
        building.name = name
        building.link = link
        
        do {
            //3
            try managedContext!.save()
        } catch _ {
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

    /*
    class func makeFrame(x: Int, y: Int, width: Int, height: Int) -> CGRect {
        return CGRectMake( CGFloat(x), CGFloat(y), CGFloat(width), CGFloat(height) )
    }*/
    
    class func themeColor() -> UIColor {
        return colorWithHexString("1E466B")
    }

    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

}
