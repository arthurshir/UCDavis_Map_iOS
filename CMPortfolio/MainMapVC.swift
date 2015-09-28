//
//  MainMapVC.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 9/25/15.
//  Copyright (c) 2015 Aashir. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import AddressBook

class MainMapVC: UIViewController, GMSMapViewDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    
    // ---------- ViewDid... ---------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupSearch()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshMap()
    }
    
    // ---------- Variables ---------- //
    @IBOutlet var searchBar: UISearchBar!
    var buildingsToHide = [AnyObject]()
    var visibleBuildings = [AnyObject]()
    var buildingObjects = NSMutableArray()
    var buildings = [AnyObject]()
    var buildingToSend : BuildingObject?
    var savedSearch = ""
    @IBOutlet var mapView: GMSMapView!
    
    // ---------- Retrieval ---------- //
    
    func refreshMap() {
        Functions.getBuildings { (success, buildings) -> Void in
            if (success == nil) {
                // Error
            } else {
                self.buildings = buildings!
                self.visibleBuildings = buildings!
                self.addToMap()
            }
        }
    }
    
    func addToMap() {
        mapView.clear()
        buildingObjects.removeAllObjects()
        for (var i = 0; i < buildings.count; i++) {
            if let building = buildings[i] as? PFObject {
                var point = building.objectForKey("location") as? PFGeoPoint
                var name = building.objectForKey("name") as? String
                var description = building.objectForKey("description") as? String
                if point != nil {
                    var marker = LabelMarker.markerWithText(name!)
                    marker.position = CLLocationCoordinate2DMake(point!.latitude, point!.longitude)
                    //marker.appearAnimation = kGMSMarkerAnimationPop
                    marker.map = mapView
                    marker.building = BuildingObject.makeBuilding(name!, coords: marker.position)
                    buildingObjects.addObject( BuildingObject.makeBuilding(name!, coords: marker.position) )
                    
                } else {
                    println("MMVC: point was nil?")
                }
                
            } else {
                println("MMVC: Not PFObject?")
            }
            
        }
    }
    
    func setVisibleOnMap() {
        mapView.clear()
        var bounds = GMSCoordinateBounds()
        for (var i = 0; i < visibleBuildings.count; i++) {
            var bo = visibleBuildings[i] as! BuildingObject
            var marker = LabelMarker.markerWithText(bo.name!)
            marker.position = bo.coords!
            marker.map = mapView
            marker.building = bo
            bounds.includingCoordinate(bo.coords!)
        }
        
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 30 ))
        
    }
    
    // ---------- Search ---------- //
    
    @IBAction func touchSearch(sender: AnyObject) {
        searchBar.hidden = !searchBar.hidden
        if !searchBar.hidden == true {
            // SearchBar Enabled
            searchBar.text = savedSearch
            searchBar.becomeFirstResponder()
            filterContentForText(searchBar.text)
            setVisibleOnMap()
        } else {
            // SearchBar Disabled
            searchBar.resignFirstResponder()
            savedSearch = searchBar.text
            searchBar.text = ""
            filterContentForText("")
            setVisibleOnMap()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        filterContentForText(searchBar.text)
        searchBar.resignFirstResponder()
        savedSearch = searchBar.text
        searchBar.hidden = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForText(searchText)
        setVisibleOnMap()
    }
    
    func filterContentForText(searchText: String) {
        if searchText == "" {
            visibleBuildings = buildingObjects as [AnyObject]
        } else {
            var resultPredicate = NSPredicate(format: "name contains[c] %@", searchText)
            visibleBuildings = buildingObjects.filteredArrayUsingPredicate(resultPredicate)
        }
    }
    
    // ---------- Setup ---------- //
    
    func setupSearch() {
        searchBar.hidden = true
    }
    
    func setupMap() {
        var camera = GMSCameraPosition.cameraWithLatitude(38.5382322, longitude: -121.756, zoom: 14)
        mapView.camera = camera
        mapView.setMinZoom(13.5, maxZoom: 50)
        mapView.delegate = self
        searchBar.delegate = self
        
    }
    
     // ---------- Delegate ---------- //
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        buildingToSend = (marker as! BuildingMarker).building
        //performSegueWithIdentifier("ShowBuildingDetail", sender: self)
        return false
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        var building = buildingToSend!
        let destination = building.coords!
        var header = building.name!
        let addressDict = [ kABPersonAddressStreetKey as NSString: header ]
        
        var place = MKPlacemark(coordinate: destination, addressDictionary: addressDict)
        var options =  [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        MKMapItem.openMapsWithItems([ MKMapItem.mapItemForCurrentLocation() ,MKMapItem(placemark: place)], launchOptions: options)
    }



}
