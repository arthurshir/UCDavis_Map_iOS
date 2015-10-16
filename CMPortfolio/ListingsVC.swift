//
//  ListingsVC.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 10/15/15.
//  Copyright © 2015 Aashir. All rights reserved.
//

import UIKit

class ListingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    let sections = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var savedLoc = [LocationObj]()
    var visible = [LocationObj]()
    var sectionedArr = [AnyObject]()
    var savedPath : NSIndexPath?
    var searchShowing = false
    var categoryIndex = 0
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var SearchDC: UISearchDisplayController!

    
    
    
    @IBAction func touchSearch(sender: AnyObject) {
        searchBar.translatesAutoresizingMaskIntoConstraints = true
        
        if (!searchShowing) {
            UIView.beginAnimations("showBar", context: nil)
            UIView.setAnimationDuration(0.1)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
            searchBar.frame = CGRectMake(searchBar.frame.origin.x, 0, searchBar.frame.width, searchBar.frame.height)
            view.layoutIfNeeded()
            UIView.commitAnimations()
            
            navigationController?.setNavigationBarHidden(true, animated: false)
            searchBar.becomeFirstResponder()
            navigationController?.setNavigationBarHidden(false, animated: false)
            
            searchShowing = true
        } else {
            
            UIView.beginAnimations("hideBar", context: nil)
            UIView.setAnimationDuration(0.1)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
            searchBar.frame = CGRectMake(searchBar.frame.origin.x, -44, searchBar.frame.width, searchBar.frame.height)
            view.layoutIfNeeded()
            UIView.commitAnimations()
            
            filterContentForText("")
            SearchDC.setActive(false, animated: true)
            searchShowing = false
        }
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        UIView.beginAnimations("hideBar", context: nil)
        UIView.setAnimationDuration(0.1)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
        searchBar.frame = CGRectMake(searchBar.frame.origin.x, -44, searchBar.frame.width, searchBar.frame.height)
        view.layoutIfNeeded()
        UIView.commitAnimations()
        
        filterContentForText("")
        searchShowing = false
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        filterContentForText(searchString!)
        return true
    }

    
    func filterContentForText(searchText: String) {
        if searchText == "" {
            visible = savedLoc
            sectionTheVisible()
        } else {
            let resultPredicate = NSPredicate(format: "name contains[c] %@", searchText)
            let mArr = NSMutableArray(array: savedLoc)
            visible = mArr.filteredArrayUsingPredicate(resultPredicate) as! [LocationObj]
            sectionTheVisible()
        }
    }
    
    func sectionTheVisible() {
        sectionedArr.removeAll()
        for chstr in sections {
            var arr = [LocationObj]()
            for locObj in visible {
                if locObj.name[locObj.name.startIndex] == chstr[chstr.startIndex] {
                    arr.append(locObj)
                }
            }
            sectionedArr.insert(arr, atIndex: sectionedArr.count)
        }
        tableView.reloadData()
    }
    

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !(self.navigationController!.viewControllers.contains(self)) {
            SearchDC.setActive(false, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Table
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchDisplayController?.delegate = self
        
        // Set Organized Locations
        sectionedArr.removeAll()
        savedLoc = Functions.returnArray(categoryIndex) as! [LocationObj]
        for chstr in sections {
            var arr = [LocationObj]()
            for locObj in savedLoc {
                if locObj.name[locObj.name.startIndex] == chstr[chstr.startIndex] {
                    arr.append(locObj)
                }
            }
            sectionedArr.insert(arr, atIndex: sectionedArr.count)
        }
        visible = savedLoc
        navigationItem.title = Functions.returnCategoryName(categoryIndex)
        
    }
    
    override  func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.clipsToBounds = false
        
        // Reload Favorites Table if category is favorites
        if categoryIndex == 5 {
            
            // Set Organized Locations
            sectionedArr.removeAll()
            savedLoc = Functions.returnArray(categoryIndex) as! [LocationObj]
            for chstr in sections {
                var arr = [LocationObj]()
                for locObj in savedLoc {
                    if locObj.name[locObj.name.startIndex] == chstr[chstr.startIndex] {
                        arr.append(locObj)
                    }
                }
                sectionedArr.insert(arr, atIndex: sectionedArr.count)
            }
            visible = savedLoc
            tableView.reloadData()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 26
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sa = sectionedArr[section] as! [LocationObj]
        return sa.count
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sa = sectionedArr[section] as? [LocationObj]
        if (sa == nil || sa!.count == 0) {
            return 0
        }
        
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let locObj = (sectionedArr[indexPath.section] as! [LocationObj])[indexPath.row]
        cell.textLabel?.text = locObj.name
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        savedPath = indexPath
        return indexPath
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMap" {
            let a = segue.destinationViewController as! OneLocationMapVC
            a.savedLocObj = (sectionedArr[savedPath!.section] as! [LocationObj])[savedPath!.row]
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
