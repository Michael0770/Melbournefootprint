//
//  Artwork.swift
//  HonoluluArt
//
//  Created by Audrey M Tam on 6/11/2014.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class ArtworkForMap: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D

    
    


    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    class func fromJSON(json: [JSONValue]) -> ArtworkForMap? {
        // 1
        var title: String
        if let titleOrNil = json[6].string {
            title = titleOrNil
        } else {
            title = ""
        }
        let locationName = json[0].string
        let discipline = json[5].string
        
        // 2
        let fullName: String = json[3].string!
        let fullNameArr = fullName.componentsSeparatedByString(",")
        
        var firstName: String = fullNameArr[0]
        var lastName: String = fullNameArr[1]
        
        var latitude1 = String(firstName.characters.dropFirst())
        var longtitude1 = String(lastName.characters.dropLast())
        
        
        let latitude = (latitude1  as NSString).doubleValue
        let longitude = (longtitude1 as NSString).doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 3f
        return ArtworkForMap(title: title, locationName: locationName!, discipline: discipline!, coordinate: coordinate)
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // MARK: - MapKit related methods
    
    // pinColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    func pinColor() -> MKPinAnnotationColor  {
        switch discipline {
        case "Sculpture", "Plaque":
            return .Red
        case "Mural", "Monument":
            return .Purple
        default:
            return .Green
        }
    }
    
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [String(kABPersonAddressStreetKey): self.subtitle]
        //let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        var addressDictionary : [String:String]?
        
        if let subtitle = subtitle {
            // The subtitle value used here is a String,
            // so addressDictionary conforms to its [String:String] type
            addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        }
        
        
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }
    
}
