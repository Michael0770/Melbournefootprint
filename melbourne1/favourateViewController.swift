//
//  favourateViewController.swift
//  melbourne1
//
//  Created by zihaowang on 14/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GoogleSignIn
import FBSDKLoginKit
class favourateViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate {
    var artworks = [Artworks]()
    var userid:String?
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var favourateTableView: UITableView!
    @IBAction func logInViewButton(sender: AnyObject) {
        
    }
    @IBAction func refreshAc(sender: AnyObject) {
        self.viewWillAppear(true)
    }
    
    @IBAction func favoriteLoginAction(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
self.view.setNeedsDisplay()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.favourateTableView.delegate = self
        self.favourateTableView.dataSource = self
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            self.userid = user.uid
            self.favourateTableView.hidden = false
            self.loginButton.hidden = true
            self.refreshButton.hidden = true

            artworks.removeAll()
            self.favourateTableView.reloadData()
            fetchArtworks()
        } else {
            // No user is signed in.
            self.favourateTableView.hidden = true
            self.loginButton.hidden = false
        }
        
    }
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        self.favourateTableView.delegate = self
    //        self.favourateTableView.dataSource = self
    //        if let user = FIRAuth.auth()?.currentUser {
    //            // User is signed in.
    //
    //
    //
    //            self.userid = user.uid
    //            print(self.userid)
    //            self.favourateTableView.hidden = false
    //            self.loginButton.hidden = true
    //            fetchArtworks()
    //        } else {
    //            // No user is signed in.
    //            self.favourateTableView.hidden = true
    //            self.loginButton.hidden = false
    //
    //        }
    //
    //            }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return artworks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favouriteTableCell", forIndexPath: indexPath) as! favouriteTableCell
        
        let locationManager1 = CLLocationManager()
        locationManager1.delegate = self
        locationManager1.desiredAccuracy = kCLLocationAccuracyBest
        locationManager1.requestWhenInUseAuthorization()
        locationManager1.startUpdatingLocation()
        let locValue:CLLocationCoordinate2D = locationManager1.location!.coordinate
        
        let currentlocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        cell.addressL.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.addressL.numberOfLines = 0;
        cell.nameL.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.nameL.numberOfLines = 0;
        
        let artwork : Artworks
        
        artwork = artworks[indexPath.row]
        
        cell.nameL.text = artwork.Name
        
        let fullNameArr = artwork.Coordinates!.componentsSeparatedByString(",")
        
        let firstName: String = fullNameArr[0]
        let lastName: String = fullNameArr[1]
        
        let latitude1 = String(firstName.characters.dropFirst())
        let longtitude1 = String(lastName.characters.dropLast())
        
        
        let latitude2 = (latitude1  as NSString).doubleValue
        let longitude2 = (longtitude1 as NSString).doubleValue
        
        let initialLocation = CLLocation(latitude: latitude2, longitude: longitude2)
        
        let distance = currentlocation.distanceFromLocation(initialLocation)
        let doubleDis : Double = distance
        let intDis : Int = Int(doubleDis)
        
        cell.addressL.text = "\(intDis)m"
        if let photo = artwork.Photo{
            cell.tableImageView.loadImageUsingCacheWithUrlString(photo)
            print(photo)
            
        }
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
        
    }
    
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let ref = FIRDatabase.database().referenceFromURL("https://melbourne-footprint.firebaseio.com/")
            ref.child("users/\(self.userid!)/favorite/\(artworks[indexPath.row].Name!)").removeValue()
            self.artworks.removeAtIndex(indexPath.row)
            self.favourateTableView.reloadData()
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewArtwork3"
        {
            
            let indexPath = self.favourateTableView.indexPathForSelectedRow!
            let controller: ViewDetailsController = segue.destinationViewController
                as! ViewDetailsController
            let artworkDetail: Artworks
            artworkDetail = artworks[indexPath.row]
            
            
            controller.currentArtwork = artworkDetail            //self.tabBarController?.tabBar.hidden = true
            controller.hidesBottomBarWhenPushed = true
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    
    //get data from database
    func fetchArtworks(){
        //let initialLocation = CLLocation(latitude: -37.8885677, longitude: 145.045028)
        //let i111 = self.locationManager1.locatio
        let ref = FIRDatabase.database().referenceFromURL("https://melbourne-footprint.firebaseio.com/")
        ref.child("users/\(self.userid!)/favorite").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let artwork = Artworks()
                artwork.setValuesForKeysWithDictionary(dictionary)
                self.artworks.append(artwork)
                dispatch_async(dispatch_get_main_queue(),{self.favourateTableView.reloadData() } )
            }
            }, withCancelBlock: nil)
        
        
        
    }
    
    
}
