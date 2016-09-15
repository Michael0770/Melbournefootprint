//
//  TableViewController.swift
//  melbourne1
//
//  Created by zihaowang on 18/08/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {
    var flag : Bool?
    var index = 1;
    let searchController = UISearchController(searchResultsController:nil)
    @IBOutlet weak var allItemT: UIBarButtonItem!
    //set nearby and all transform
    @IBAction func allItem(sender: AnyObject) {
        if self.index%2 != 0{
            self.flag = true
            artworks.removeAll()
            self.tableView.reloadData()
            fetchArtworks()
            self.allItemT.title="Nearby"
            self.navigationItem.title = "ALL"
            self.index = index + 1
        }
        else
        {
            self.flag = false
            artworks.removeAll()
            self.tableView.reloadData()
            fetchArtworks()
            self.allItemT.title="All"
            self.navigationItem.title = "Nearby"
            self.index = index + 1
        }

    }
    
    
    //add search function
    var artworks = [Artworks]()
    var filteredArtwork = [Artworks]()
    func filterContentForSearchText(searchText:String,scope:String = "All"){
        filteredArtwork = artworks.filter{
            artwork in
            return artwork.Name!.lowercaseString.containsString(searchText.lowercaseString) || artwork.Date!.containsString(searchText) ||
                artwork.Artist!.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.flag = false
        fetchArtworks()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    //get data from database
    func fetchArtworks(){
        
        let locationManager1 = CLLocationManager()
        locationManager1.delegate = self
        locationManager1.desiredAccuracy = kCLLocationAccuracyBest
        locationManager1.requestWhenInUseAuthorization()
        locationManager1.startUpdatingLocation()
        
        let locValue:CLLocationCoordinate2D = locationManager1.location!.coordinate
        
        
        //let initialLocation = CLLocation(latitude: -37.8885677, longitude: 145.045028)
        let currentlocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        //let i111 = self.locationManager1.location
        
        
        let ref = FIRDatabase.database().referenceFromURL("https://melbourne-footprint.firebaseio.com/")
        
        ref.childByAppendingPath("Heritage").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let artwork = Artworks()
                artwork.setValuesForKeysWithDictionary(dictionary)
                
                let fullNameArr = artwork.Coordinates!.componentsSeparatedByString(",")
                
                let firstName: String = fullNameArr[0]
                let lastName: String = fullNameArr[1]
                
                let latitude1 = String(firstName.characters.dropFirst())
                let longtitude1 = String(lastName.characters.dropLast())
                
                
                let latitude2 = (latitude1  as NSString).doubleValue
                let longitude2 = (longtitude1 as NSString).doubleValue
                
                let initialLocation = CLLocation(latitude: latitude2, longitude: longitude2)
                
                let distance = currentlocation.distanceFromLocation(initialLocation)
                if self.flag == true{
                    self.artworks.append(artwork)
                }
                    //judge nearby distance
                else if self.flag == false{
                    if distance < 1500{
                        self.artworks.append(artwork)
                        
                        for i in 0 ..< self.artworks.count {
                            for j in 1 ..< self.artworks.count-i {
                                
                                
                                
                                
                                let full = self.artworks[j-1].Coordinates!.componentsSeparatedByString(",")
                                
                                let first: String = full[0]
                                let last: String = full[1]
                                
                                let lat1 = String(first.characters.dropFirst())
                                let long1 = String(last.characters.dropLast())
                                
                                
                                let lat2 = (lat1 as NSString).doubleValue
                                let long2 = (long1 as NSString).doubleValue
                                
                                let LocationJx = CLLocation(latitude: lat2, longitude: long2)
                                
                                let distanceJx = currentlocation.distanceFromLocation(LocationJx) as Double
                                
                                let fullj = self.artworks[j].Coordinates!.componentsSeparatedByString(",")
                                
                                let firstj: String = fullj[0]
                                let lastj: String = fullj[1]
                                
                                let lat1j = String(firstj.characters.dropFirst())
                                let long1j = String(lastj.characters.dropLast())
                                
                                
                                let lat2j = (lat1j  as NSString).doubleValue
                                let long2j = (long1j as NSString).doubleValue
                                
                                let LocationJ = CLLocation(latitude: lat2j, longitude: long2j)
                                
                                let distanceJ = currentlocation.distanceFromLocation(LocationJ) as Double
                                
                                
                                if distanceJ < distanceJx {
                                    let swap = self.artworks[j-1]
                                    self.artworks[j-1] = self.artworks[j]
                                    self.artworks[j] = swap
                                }
                            }
                        }
                    }
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
        if searchController.active && searchController.searchBar.text != "" {
            return filteredArtwork.count
        }
        
        return artworks.count
    }
    
    //define cell in tablebar to show artwokr
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
        
        let artwork : Artworks
        if searchController.active && searchController.searchBar.text != "" {
            artwork = filteredArtwork[indexPath.row]
        }else {
            artwork = artworks[indexPath.row]
        }
        
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
    

    
    // MARK: - Navigation
    
    // pass selected artwokr to detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewArtwork"
        {
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            let controller: ViewDetailsController = segue.destinationViewController
                as! ViewDetailsController
            let artworkDetail: Artworks
            if searchController.active && searchController.searchBar.text != "" {
                artworkDetail = filteredArtwork[indexPath.row]
            }else {
                artworkDetail = artworks[indexPath.row]
            }
            
            
            controller.currentArtwork = artworkDetail            //self.tabBarController?.tabBar.hidden = true
            controller.hidesBottomBarWhenPushed = true
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
//update  content when seaching.
extension TableViewController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController:UISearchController)
    {
        filterContentForSearchText(searchController.searchBar.text!)
}
}
