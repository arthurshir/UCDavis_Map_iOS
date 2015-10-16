//
//  OneLocationMapVC.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 10/14/15.
//  Copyright © 2015 Aashir. All rights reserved.
//

import CoreData
import AddressBookUI

class OneLocationMapVC: UIViewController, GMSMapViewDelegate {

    var isFavorited = false
    var savedLocObj : LocationObj?
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        CLLocationManager().startUpdatingLocation()
        
        mapView.delegate = self
        let camera = GMSCameraPosition.cameraWithLatitude(savedLocObj!.lat, longitude: savedLocObj!.lng, zoom: 16)
        mapView.camera = camera
        mapView.setMinZoom(14.2, maxZoom: 17.5)
        
        let marker = LabelMarker.largeMarkerWithText(savedLocObj!.name)
        marker.position = CLLocationCoordinate2DMake( CLLocationDegrees(savedLocObj!.lat), CLLocationDegrees(savedLocObj!.lng))
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        mapView.myLocationEnabled = true
        
        favoriteButton.image = nil
    
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Buildings")
        request.predicate = NSPredicate(format: "name ==%@", savedLocObj!.name)
        let buil = try? managedContext!.executeFetchRequest(request)
        if ( buil!.count == 0 ) {
            isFavorited = false
            favoriteButton.image = UIImage(named: "Nav_Favorite0")
        } else {
            isFavorited = true
            favoriteButton.image = UIImage(named: "Nav_Favorite1")
        }
    }
    
    @IBAction func touchFavoriteButton(sender: AnyObject) {
        if (isFavorited == true) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let request = NSFetchRequest(entityName: "Buildings")
            request.predicate = NSPredicate(format: "name ==%@", savedLocObj!.name)
            let buil = try? managedContext!.executeFetchRequest(request)
            if ( buil!.count != 0 ) {
                for b in buil! {
                    managedContext!.deleteObject(b as! NSManagedObject)
                }
                do {
                    try managedContext!.save()
                } catch {
                    print("OLMVC: Save error?")
                }
            }
            isFavorited = false
            favoriteButton.image = UIImage(named: "Nav_Favorite0")
        } else {
            Functions.saveBuilding(savedLocObj!.lat, lng: savedLocObj!.lng, name: savedLocObj!.name, link: savedLocObj!.link)
            isFavorited = true
            favoriteButton.image = UIImage(named: "Nav_Favorite1")
        }
    }
    
    // ---------- Map Info Window ---------- //
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        let destination = CLLocationCoordinate2D(latitude: savedLocObj!.lat, longitude: savedLocObj!.lng)
        let header = savedLocObj!.name
        let addressDict = [ kABPersonAddressStreetKey as String : header ]
        let place = MKPlacemark(coordinate: destination, addressDictionary: addressDict)
        var options =  [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMapsWithItems([ MKMapItem.mapItemForCurrentLocation() ,MKMapItem(placemark: place)], launchOptions: options)
        
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        return UIImageView(image: UIImage(named: "Direction"))
    }


}
