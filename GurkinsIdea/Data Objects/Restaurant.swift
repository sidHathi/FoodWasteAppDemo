//
//  Restaurant.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import Firebase
import SwiftUI
import UIKit

/**
Description:
Type: DataClass
Functionality: This Class provides a location where basic information regarding
a Restaurant can be stored and access by a user who is not a Restaurant.
Rather than using a RestaurantProfile Object, these user's store information regarding
restaurants in their area within a dataclass of this nature. This separation exists mainly for
privacy reasons.
*/
class Restaurant
{
    // Instance variables
    var address: String
    var id = UUID()
    var name: String
    var availability: Bool
    var isFavorite: Bool
    var description: String
    var coordinates: CLLocationCoordinate2D
    var availableFood: [Food]
    var reservedFood: [Food]?
    var pickUps: [Pickup]
    var uid: String?
    var phone: String?
    var image: UIImage?
    var aIDs: [String]?
    var rIDs: [String]?
    var cPIDs: [String]?
    var phIDs: [String]?
    
    // Defaults used to artifically populate demos
   static let `bellevue` = Restaurant(address: "Bellevue", name: "Pagliacci Pizza", availability: true, favorite: true, description: "Pagliacci Pizza, serving Seattle's best pizza since 1979. Offering pizza by the slice and pizza delivery service to homes and businesses.", coordinates: CLLocationCoordinate2D(latitude: 47.7, longitude: -122.3), availableFood: [], pickUps: [])
    
   static let `withFood` = Restaurant(address: "Bellevue", name: "Pagliacci Pizza", availability: true, favorite: true, description: "Pagliacci Pizza, serving Seattle's best pizza since 1979. Offering pizza by the slice and pizza delivery service to homes and businesses.", coordinates: CLLocationCoordinate2D(latitude: 47.7, longitude: -122.3), availableFood: [Food(), Food()], pickUps: [])
    
    // Main constructor: takes in JSON file converted into datamap from firebase and creates Restaurant object
    // whose instance variables are populated based on information contained within the datamap.
    init(data: [String: Any], uid: String)
    {
        self.name = data["name"]! as! String
        self.address = data["address"] as! String
        let latitude = data["latitude"] as! Double
        let longitude = data["longitude"] as! Double
        self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.availability = false
        self.isFavorite = false
        self.description = data["description"] as! String
        
        if (data["availableFood"] != nil)
        {
            let available = data["availableFood"] as! [String]
            self.aIDs = available
        }
        self.availableFood = []
        
        
        if (data["reservedFood"] != nil)
        {
            let reserved = data["reservedFood"] as! [String]
            self.rIDs = reserved
        }
        self.reservedFood = []
        
        self.pickUps = []
        self.phone = data["phone"] as! String
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageURL = data["imageURL"] as! String
        let httpsReference = storage.reference(forURL: imageURL)
        
        let imageRef = httpsReference.child("images/userPhoto.jpg")
        var image = UIImage(named: "pagsLogo")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            image = UIImage(named: "pagsLogo")
          } else {
            // Data for "images/island.jpg" is returned
            image = UIImage(data: data!)
          }
        }
        self.image = image!
        self.uid = uid
    }
    
    // Constructor used to populate Restaurants manually - used mainly for demo purposes
    init(address: String, name: String, availability: Bool, favorite: Bool, description: String, coordinates: CLLocationCoordinate2D, availableFood: [Food], pickUps: [Pickup])
    {
        self.address = address
        self.name = name
        self.availability = availability
        self.isFavorite = favorite
        self.description = description
        self.coordinates = coordinates
        self.pickUps = pickUps
        self.availableFood = availableFood
    }

    // Constructor used to setup Restaurant object based on input from setup view
    init(address: String, name: String, availability: Bool, favorite: Bool, description: String, availableFood: [Food], pickUps: [Pickup])
    {
        self.address = address
        self.name = name
        self.availability = availability
        self.isFavorite = favorite
        self.description = description
        self.coordinates = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
        if address != nil || address != ""
        {
            let geoCoder = CLGeocoder()
            var coordinate = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
            geoCoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error ?? "")
                }
                if let placemark = placemarks?.first {
                    coordinate = placemark.location!.coordinate
                }
            })
            self.coordinates = coordinate
        }
        self.availableFood = availableFood
        self.pickUps = pickUps
    }
    
    // Default constructor used to populate demos
    init()
    {
        self.address = "Seattle"
        self.name = "Pagliacci Pizza"
        self.availability = true
        self.isFavorite = false
        self.description = "Pagliacci Pizza, serving Seattle's best pizza since 1979. Offering pizza by the slice and pizza delivery service to homes and businesses."
        self.coordinates = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
        self.availableFood = []
        self.pickUps = []
    }
    
    // function used to append pickups
    func addOrder(order: Pickup)
    {
        self.pickUps.append(order)
    }
    
    // function used to compare restaurants
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        if (lhs.address == rhs.address && lhs.name == rhs.name)
        {
            return true
        }
        return false
    }
}



