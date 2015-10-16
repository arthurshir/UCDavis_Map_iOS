//
//  BuildingDetailVC.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 9/26/15.
//  Copyright (c) 2015 Aashir. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class BuildingDetailVC: UIViewController {

    var building : PFObject?
    
    @IBOutlet var buildingLabel: UILabel!
    @IBAction func touchDirections(sender: AnyObject) {

        /*
        var point = building!.objectForKey("location") as? PFGeoPoint
        if point != nil {
            
        
            let destination = CLLocationCoordinate2D(latitude: point!.latitude, longitude: point!.longitude)
            var header = building!.objectForKey("name") as! String
            let addressDict = [ kABPersonAddressStreetKey as NSString: header ]
            
            var place = MKPlacemark(coordinate: destination, addressDictionary: addressDict)
            var options =  [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            
            MKMapItem.openMapsWithItems([ MKMapItem.mapItemForCurrentLocation() ,MKMapItem(placemark: place)], launchOptions: options)
        }
        */
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if building != nil {
            buildingLabel.text = building!.objectForKey("name") as? String
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
