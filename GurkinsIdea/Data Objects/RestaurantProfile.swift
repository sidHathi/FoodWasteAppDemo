//
//  RestaurantProfile.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/20/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

/**
Description:
Type: DataClass
Functionality: This class is where the vast body of information regarding restaurant users
 is stored. This data includes. Objects of this class are stored within the app and used by
 all the view controllers to determine what the user should see.
*/
class RestaurantProfile
{
    // Instance vars
    var name: String
    var address: String
    var description: String
    var phone: String
    var location: CLLocationCoordinate2D
    var availability: Bool
    var availableFood: [Food]
    var aIDs: [String]?
    var reservedFood: [Food]
    var rIDs: [String]?
    var currentPickups: [Pickup]
    var cPIDs: [String]?
    var pickupHistory: [Pickup]
    var phIDs: [String]?
    var image = Image("restaurantGeneric")
    
    // Function that generates a Firebase-formatted dataMap based on the information stored within
    // the object's instance variables. Used to store new user profiles on Firebase.
    func returnDataMap() -> [String: Any]
    {
        return ["name": self.name,
                "address": self.address,
                "description": self.description,
                "phone": self.phone,
                "latitude": self.location.latitude,
                "longitude": self.location.longitude,
                "availableFood": self.aIDs as Any,
                "reservedFood": self.rIDs as Any,
                ]
    }
    
    // Main constructor: takes in JSON file converted into datamap from firebase and creates RestaurantProfile object
    // whose instance variables are populated based on information contained within the datamap.
    init(data: [String: Any])
    {
        //let restaurantProfile = RestaurantProfile(name: document.data()!["name"] as! String, address: document.data()!["address"] as! String, description: document.data()!["description"] as! String, phone: document.data()!["phone"] as! String, location: CLLocationCoordinate2D(latitude: document.data()!["latitude"] as! Double, longitude: document.data()!["longitude"] as! Double), availability: false, aFood: [], rFood: [], cPickups: [], history: [])
        self.name = data["name"] as! String
        self.address = data["address"] as! String
        self.description = data["description"] as! String
        self.phone = data["phone"] as! String
        self.location = CLLocationCoordinate2D(latitude: data["latitude"] as! Double, longitude: data["longitude"] as! Double)
        self.availability = false
        
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
        
        if (data["current"] != nil)
        {
            let current = data["current"] as! [String]
            self.cPIDs = current
        }
        self.currentPickups = []
        
        self.pickupHistory = []
    }
    
    // Constructor that creates RestaurantProfile object from locally stored info
    init(name: String, address: String, description: String, phone: String, location: CLLocationCoordinate2D, availability: Bool, aFood: [Food], rFood: [Food], cPickups: [Pickup], history: [Pickup])
    {
        self.name = name
        self.address = address
        self.description = description
        self.phone = phone
        self.location = location
        self.availability = availability
        self.availableFood = aFood
        self.reservedFood = rFood
        self.currentPickups = cPickups
        self.pickupHistory = history
    }
    
    // Default constructor
    init()
    {
        self.name = ""
        self.address = ""
        self.description = ""
        self.phone = ""
        self.location = CLLocationCoordinate2D()
        self.availability = false
        self.availableFood = []
        self.reservedFood = []
        self.currentPickups = []
        self.pickupHistory = []
    }
}
