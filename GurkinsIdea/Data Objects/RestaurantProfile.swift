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

class RestaurantProfile
{
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
