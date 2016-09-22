//
//  searchAllController.swift
//  melbourne1
//
//  Created by zihaowang on 15/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation
import Firebase
class searchAllController: UITableViewController,CLLocationManagerDelegate {
    let  flag = true
    var index = 1;
    var userid:String?
    let searchController = UISearchController(searchResultsController:nil)
    //add search function
    var artworks = [Artworks]()
    var filteredArtwork = [Artworks]()
    var menuView: BTNavigationDropdownMenu!
    var category : String?
    var favoriteArtwork = [Artworks]()

    func filterContentForSearchText(searchText:String,scope:String = "All"){
        filteredArtwork = artworks.filter{
            artwork in
            return artwork.Name!.lowercaseString.containsString(searchText.lowercaseString) || artwork.Date!.containsString(searchText) ||
                artwork.Artist!.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            self.userid = user.uid
            self.favoriteArtwork.removeAll()
            fetchFavoriteArtworks()
            
        } else {
            // No user is signed in.
            
        }
        
        fetchArtworks()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        
        self.category = "All"
        self.fetchArtworks()
        let items = ["All", "Artwork", "HeritageBuilding", "Gallery/Museum"]
        //self.selectedCellLabel.text = items.first
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()//UIColor(red: 2.0, green:0.0, blue:0.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "All", items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor.darkGrayColor()//UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
        print("Did select item at index: \(indexPath)")
        self.artworks.removeAll()
        self.tableView.reloadData()
        self.category = items[indexPath]
        self.fetchArtworks()
        }
        self.navigationItem.titleView = menuView
       
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar

    }
    
    func fetchFavoriteArtworks(){
        let ref = FIRDatabase.database().referenceFromURL("https://melbourne-footprint.firebaseio.com/")
        ref.child("users/\(self.userid!)/favorite").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let artwork = Artworks()
                artwork.setValuesForKeysWithDictionary(dictionary)
                self.favoriteArtwork.append(artwork)
                
            }
            }, withCancelBlock: nil)
        
        
        
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
                
                if self.flag == true && self.category == "All"{
                    self.artworks.append(artwork)
                
                }
                else if self.flag == true && artwork.Structure == self.category{
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
        let cell = tableView.dequeueReusableCellWithIdentifier("searchAllCell", forIndexPath: indexPath) as! searchAllCellController
        
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
        if self.userid != nil
        {
            for currentArk in self.favoriteArtwork
            {
                if artwork.Name == currentArk.Name
                {
                    let image = UIImage(named: "heart_icon_selected")
                    cell.faButton.setImage(image, forState: UIControlState.Normal)
                    cell.isFavorate2 = true
                }
                
            }
            
        }

        cell.noLoginButtonTapped = {
            let alertController = UIAlertController(title: "Reminder", message:
            "Please sign in to add favorite", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
}
        cell.onButtonTapped = {
            if let user = FIRAuth.auth()?.currentUser {
                // User is signed in.
                let uid = user.uid
                let ref = FIRDatabase.database().referenceFromURL("https://melbourne-footprint.firebaseio.com/")
                print(!cell.isFavorate2)
                if !cell.isFavorate2
                {
                    ref.child("users/\(uid)/favorite/\(artwork.Name!)").setValue(["Address": "\(artwork.Address!)",
                        "AlternateName": "",
                        "Artist": "\(artwork.Artist!)",
                        "Coordinates": "\(artwork.Coordinates!)",
                        "Date": "\(artwork.Date!)",
                        "Descriptions": "\(artwork.Descriptions!)",
                        "Name": "\(artwork.Name!)",
                        "Photo": "\(artwork.Photo!)",
                        "Structure": "\(artwork.Structure!)",
                        "PhotoOne": "\(artwork.PhotoOne!)",
                        "PhotoTwo": "\(artwork.PhotoTwo!)",
                        "location": "\(artwork.location!)"])
                }
                else
                {
                    ref.child("users/\(uid)/favorite/\(artwork.Name!)").removeValue()
                    
                }
            } else {
                // No user is signed in.
                
            }
        }
        
      

        return cell
    }
    
    
    
    // MARK: - Navigation
    
    // pass selected artwokr to detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewArtwork2"
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
extension searchAllController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController:UISearchController)
    {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


