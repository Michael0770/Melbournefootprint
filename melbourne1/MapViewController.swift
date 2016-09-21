//
//  MapViewController.swift
//  melbourne1
//
//  Created by Michael on 19/08/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
class MapViewController: UIViewController ,CLLocationManagerDelegate{
    var awork : ArtworkForMap?
    var reallart : Artworks?
    var artworks = [ArtworkForMap]()
    var reallartworks = [Artworks]()
    //var csss : CLLocationCoordinate2D?
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationManager1 = CLLocationManager()
    
    @IBAction func mapTypeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Satellite
        case 2:
            mapView.mapType = .Hybrid
        default:
            print("Unexpected segment index for map type.")
        }
    }
    
    
    @IBAction func backToCurrentLocation(sender: AnyObject) {
        
            
            
            self.locationManager1.delegate = self
            self.locationManager1.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager1.requestWhenInUseAuthorization()
            self.locationManager1.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            
                        mapView.showsUserLocation = true
            
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.locationManager1.delegate = self


        
        // Ask user for permission to use location
        // Uses description from NSLocationAlwaysUsageDescription in Info.plist
        locationManager1.requestAlwaysAuthorization()

        
        self.mapView.showsUserLocation = true
        
        
        mapView.showsUserLocation = true
    
        self.locationManager1.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager1.requestWhenInUseAuthorization()
        self.locationManager1.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        fetchArtworks()
        loadInitialData()
        mapView.addAnnotations(artworks)
        

        
    }
    
    

    
//    func addRadiusOverlayForGeotification(geotification: ArtworkForMap) {
//        mapView?.addOverlay(MKCircle(centerCoordinate: geotification.coordinate, radius: 500))
//    }
//    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Only show user location in MapView if user has authorized location tracking
        mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        
        // Notify the user when they have entered a region
        let title = "A heritage is aroud you"
        let message = "You are 50 meters away from \(region.identifier)."
        
        if UIApplication.sharedApplication().applicationState == .Active {
            // App is active, show an alert
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // App is inactive, show a notification
            let notification = UILocalNotification()
            notification.alertTitle = title
            notification.alertBody = message
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
    }

    
    
//    func addPlatformBoundary(station: Artworks) {
//        var stationPolygon: MKPolygon
//        var coords = station.platform.map { CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1) }
//        stationPolygon = MKPolygon(coordinates: &coords, count: coords.count)
//        mapView.addOverlay(stationPolygon)
//    }
    
    
    func setRegion(region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: true)
    }
    
    
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        // Zoom to new user location when updated
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span = mapView.region.span; // Use current 'zoom'
        mapView.setRegion(mapRegion, animated: true)
    }
    
        
    
    func startMonitoringGeofence(geofence: Geofence) {
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
            return
        }
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self)
        }
        let region = regionWithGeofence(geofence)
        locationManager1.startMonitoringForRegion(region)
    }

    
    func regionWithGeofence(geofence: Geofence) -> CLCircularRegion {
        let region = CLCircularRegion(center: geofence.coordinate, radius: geofence.radius, identifier: geofence.identifier)
        return region
    }
    
    


    
    func loadInitialData() {
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json");
        var readError : NSError?
        var data: NSData = try! NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
        
        // 2
        var error: NSError?
        let jsonObject: AnyObject!
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data,
                                                                    options: NSJSONReadingOptions(rawValue: 0))
        } catch var error1 as NSError {
            error = error1
            jsonObject = nil
        }
        
        // 3
        if let jsonObject = jsonObject as? [String: AnyObject] where error == nil,
            // 4
            let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
            for artworkJSON in jsonData {
                if let artworkJSON = artworkJSON.array,
                    // 5
                    artwork = ArtworkForMap.fromJSON(artworkJSON) {
                    artworks.append(artwork)
                    
                }
            }
        }
    }
    
    

    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    func fetchArtworks(){

        let ref = FIRDatabase.database().referenceFromURL("https://melbourne-footprint.firebaseio.com/")
        ref.childByAppendingPath("Heritage").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let artwork = Artworks()
                artwork.setValuesForKeysWithDictionary(dictionary)
                self.reallartworks.append(artwork)
               // dispatch_async(dispatch_get_main_queue(),{self.tableView.reloadData() } )
            }
            }, withCancelBlock: nil)
        
    }

    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude,
                                            longitude: location!.coordinate.longitude)
        
        for region in artworks{
            
            //            let current = locationManager1.location?.coordinate
            //            print(current)
            //
            let currentlocation = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            
            let initialLocation = CLLocation(latitude: region.coordinate.latitude, longitude: region.coordinate.longitude)
            
            let distance = currentlocation.distanceFromLocation(initialLocation)
            
          //  print("Monitoring \(region.title) region")
            // Using 1000 metre radius from center of location
            
            if distance < 1500{
                
                let geofence = CLCircularRegion(center: region.coordinate, radius: 10, identifier: region.title!)
                locationManager1.startMonitoringForRegion(geofence)
                //addRadiusOverlayForGeotification(region)
                
            }
        }

        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01,
            longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        self.locationManager1.stopUpdatingLocation()
        
    }
    

    
}
