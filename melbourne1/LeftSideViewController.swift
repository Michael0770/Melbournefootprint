//
//  LeftSideViewController.swift
//  melbourne1
//
//  Created by Michael on 15/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var tableView: UITableView!
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 2 // your number of cell here
        switch(section)
        {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        case 4: return 1
        default: return 0
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0{
        return 50.0//Choose your custom row height
        }
        if indexPath.section == 1{
        return 50.0//Choose your custom row height
        }
        if indexPath.section == 2{
            return 100.0//Choose your custom row height
        }
        if indexPath.section == 3{
            return 40.0//Choose your custom row height
        }
        if indexPath.section == 4{
            return 40.0//Choose your custom row height
        }
        return 100
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
            cell.textLabel?.text = "User"
            return cell
        }else if indexPath.section == 1
        {
            let cellIdentifier = "NotificationCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NotificationCell
            return cell
        }else if indexPath.section == 2{
            let cellIdentifier = "RadiusCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RadiusCell
            return cell

        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier("LanCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Language"
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("AboutCell", forIndexPath: indexPath)
            cell.textLabel?.text = "About"
            return cell
        }
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowDetail" {
//            let inventoryViewController = segue.destinationViewController as! InventoryViewController
//            
//            // Get selected item via table cell and pass to controller
//            if let selectedCell = sender as? UITableViewCell {
//                let indexPath = tableView.indexPathForCell(selectedCell)!
//                let selectedItem = items[indexPath.row]
//                inventoryViewController.item = selectedItem
//            }
//        }
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
}
    


