//
//  LeftSideViewController.swift
//  melbourne1
//
//  Created by Michael on 15/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase

class LeftSideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
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
        default: return 0
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0{
        return 100.0//Choose your custom row height
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

        return 100
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("UserViewCell", forIndexPath: indexPath) as! UserViewCell
            if let user = FIRAuth.auth()?.currentUser {
                let name = user.displayName
                let email = user.email
                let photo = user.photoURL
                let uid = user.uid;  // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with
                // your backend server, if you have one. Use
                // getTokenWithCompletion:completion: instead.
                print(name)
                print(email)
                print(uid)
                
                cell.userPhoto.loadImageUsingCacheWithUrlString("\(photo!)")
                cell.userNameL.text = name
                cell.userPhoto.hidden = false
                cell.userNameL.hidden = false
                cell.singninButton.hidden = true
                cell.signoutButton.hidden = false
                cell.welcomeL.text = "welcome, "
                cell.signOutAction = {
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    GIDSignIn.sharedInstance().signOut()
                    try!FIRAuth.auth()?.signOut()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    
                    })
                    
                }
            }
            else
            {
                cell.userPhoto.image = UIImage(named: "footprint")
                cell.userNameL.hidden = true
                cell.signoutButton.hidden = true
                cell.singninButton.hidden = false
                cell.welcomeL.text = "please sign in"
                
                
            }
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

        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("AboutCell", forIndexPath: indexPath)
            cell.textLabel?.text = "About"
            return cell
        }
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "aboutSegue" {
//            let inventoryViewController = segue.destinationViewController as! AboutViewController
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
        
//        if indexPath.section == 3{
//            performSegueWithIdentifier("lanSegue", sender: self)
//        }
    }
}


