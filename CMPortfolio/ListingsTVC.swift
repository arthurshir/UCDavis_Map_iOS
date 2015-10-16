//
//  ListingsTVC.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 10/13/15.
//  Copyright © 2015 Aashir. All rights reserved.
//

import UIKit

class ListingsTVC: UITableViewController {

    let sections = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var savedLoc = [LocationObj]()
    var sectionedArr = [AnyObject]()
    var savedPath : NSIndexPath?
    @IBOutlet var searchBar: UISearchBar!
    
    struct SortObj {
        var name: String
        var index: Int
    }
    
    @IBAction func touchSearch(sender: AnyObject) {
        //searchBar.frame = CGRectMake(0, 0, tableView.frame.width, 55)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar.frame = CGRectMake(0, 0, tableView.frame.width, 0)
        
        sectionedArr.removeAll()
        savedLoc = Functions.returnArray(0) as! [LocationObj]
        for chstr in sections {
            var arr = [LocationObj]()
            for locObj in savedLoc {
                if locObj.name[locObj.name.startIndex] == chstr[chstr.startIndex] {
                    arr.append(locObj)
                }
            }
            sectionedArr.insert(arr, atIndex: sectionedArr.count)
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.clipsToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 26
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sa = sectionedArr[section] as! [LocationObj]
        return sa.count
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
       return sections
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let locObj = (sectionedArr[indexPath.section] as! [LocationObj])[indexPath.row]
        cell.textLabel?.text = locObj.name
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
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
