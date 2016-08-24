//
//  TableViewController.swift
//  melbourne1
//
//  Created by zihaowang on 18/08/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {

    var artworks = [Artworks]()
    override func viewDidLoad() {
        super.viewDidLoad()
       

        
        fetchArtworks()
        
    }
    func fetchArtworks(){
        
        let locationManager1 = CLLocationManager()
        locationManager1.delegate = self
        locationManager1.desiredAccuracy = kCLLocationAccuracyBest
        locationManager1.requestWhenInUseAuthorization()
        locationManager1.startUpdatingLocation()

        
    
        
        
        
        let locValue:CLLocationCoordinate2D = locationManager1.location!.coordinate
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        //let initialLocation = CLLocation(latitude: -37.8885677, longitude: 145.045028)
        let currentlocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        //let i111 = self.locationManager1.location
       

        
        let ref = Firebase(url: "https://melbourne-footprint.firebaseio.com/")
      

        ref.childByAppendingPath("Heritage").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let artwork = Artworks()
                artwork.setValuesForKeysWithDictionary(dictionary)
                
                let fullNameArr = artwork.Coordinates!.componentsSeparatedByString(",")
                
                var firstName: String = fullNameArr[0]
                var lastName: String = fullNameArr[1]
                
                var latitude1 = String(firstName.characters.dropFirst())
                var longtitude1 = String(lastName.characters.dropLast())
                
                
                let latitude2 = (latitude1  as NSString).doubleValue
                let longitude2 = (longtitude1 as NSString).doubleValue
                
                let initialLocation = CLLocation(latitude: latitude2, longitude: longitude2)
                
                let distance = currentlocation.distanceFromLocation(initialLocation)
              
                
                if distance < 1500{
                self.artworks.append(artwork)
                
                }
                
                
                
                //self.artworks.removeAll()
                dispatch_async(dispatch_get_main_queue(),{self.tableView.reloadData() } )
        }
        }, withCancelBlock: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return artworks.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! TableViewCell

        
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

        let artwork = artworks[indexPath.row]
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

        }
        return cell
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
        if segue.identifier == "viewArtwork"
        {
        
            let indexPath = self.tableView.indexPathForSelectedRow!
            let controller: ViewDetailsController = segue.destinationViewController
            as! ViewDetailsController
            controller.currentArtwork = self.artworks[indexPath.row]
            //self.tabBarController?.tabBar.hidden = true
            controller.hidesBottomBarWhenPushed = true
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
