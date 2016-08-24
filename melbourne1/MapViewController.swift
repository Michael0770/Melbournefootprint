//
//  MapViewController.swift
//  melbourne1
//
//  Created by Michael on 19/08/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class MapViewController: UIViewController ,CLLocationManagerDelegate{

    var awork : ArtworkForMap?
    var reallart : Artworks?
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationManager1 = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager1.delegate = self
        self.locationManager1.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager1.requestWhenInUseAuthorization()
        self.locationManager1.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        fetchArtworks()
        mapView.showsUserLocation = true
    

//        
//        let locValue:CLLocationCoordinate2D = locationManager1.location!.coordinate
//       
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        
//      let initialLocation = CLLocation(latitude: -37.8885677, longitude: 145.045028)
//        let currentlocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
//        //let i111 = self.locationManager1.location
//        let distance = currentlocation.distanceFromLocation(initialLocation)
//        print("\(distance)")
        
        loadInitialData()
        mapView.addAnnotations(artworks)
        
        mapView.delegate = self
        
        // show artwork on map
        //    let artwork = Artwork(title: "King David Kalakaua", locationName: "Waikiki Gateway Park",
        //      discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921,
        //        longitude: -157.831661))
        //    mapView.addAnnotation(artwork)
    }
    
    var artworks = [ArtworkForMap]()
    var reallartworks = [Artworks]()
    
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
    
    
    func fetchArtworks(){
        
        let ref = Firebase(url: "https://melbourne-footprint.firebaseio.com/")
        
        
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
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01,
            longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        self.locationManager1.stopUpdatingLocation()
        
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let location = locations.last as! CLLocation
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        
//        self.mapView.setRegion(region, animated: true)
//    }

    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        print(#function)
//        if control == view.rightCalloutAccessoryView {
//            
//            performSegueWithIdentifier("tothemoon", sender: self)
//                    }
//       
//        
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "tothemoon"
//        {
//            
//            let indexPath = self.mapView.annotations.
//            let controller: ViewDetailsController = segue.destinationViewController
//                as! ViewDetailsController
//            controller.currentArtwork = self.artworks[indexPath.row]
//        }
//    }

    
}
