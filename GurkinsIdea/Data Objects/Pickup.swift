//
//  Pickup.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Pickup
{
    var id = UUID()
    var restaurant: Restaurant?
    var profile: Profile?
    
    var restaurantName: String
    var restaurantAddress: String
    var shelterName: String
    var shelterAddress: String
     
    var time: Date
    var complete: Bool
    var food: [Food]
    var location: CLLocationCoordinate2D
    var webID: String?
    var restaurantLocation: CLLocationCoordinate2D?
    
    var canceled = false
    var cancelationMessage: String?
    
    init(data: [String: Any], id: String)
    {
        self.webID = id
        self.restaurantName = data["restaurantName"] as! String
        self.restaurantAddress = data["restaurantAddress"] as! String
        self.shelterName = data["username"] as! String
        self.shelterAddress = data["userAddress"] as! String
        self.time = (data["time"] as! Timestamp).dateValue()
        self.complete = data["complete"] as! Bool
        self.location = CLLocationCoordinate2D(latitude: (data["location"] as! GeoPoint).latitude, longitude: (data["location"] as! GeoPoint).longitude)
        self.restaurant = Restaurant()
        self.profile = Profile()
        self.food = []
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.restaurantAddress)
        {
            (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                print("Invalid location.")
                return
            }
            self.restaurantLocation = location.coordinate
        }
        
        let db = Firestore.firestore()
        let foodIDs = data["food"] as! [String]
        
        let foodRef = db.collection("food")
        for index in (0...(foodIDs.count-1))
        {
            foodRef.document(foodIDs[index]).getDocument
            {
                (document, error) in
                if let document = document, document.exists
                {
                    let newFood = Food(data: document.data()!, webID: foodIDs[index])
                    if (data["selectedMap"] != nil)
                    {
                        let selectedMap = data["selectedMap"] as! [String: Int]
                        newFood.setSelected(newQ: selectedMap[newFood.webID!]!)
                    }
                    self.food.append(newFood)
                }
                else
                {
                    print("Document does not exist")
                }
            }
        }
        
        if (data["canceled"] != nil) && (data["cancelationMessage"] != nil)
        {
            self.canceled = data["canceled"] as! Bool
            self.cancelationMessage = data["cancelationMessage"] as? String
        }
    }
    
    init(restaurant: Restaurant, time: Date, complete: Bool, food: [Food], profile: Profile, locati: CLLocationCoordinate2D)
    {
        self.restaurant = restaurant
        self.restaurantName = restaurant.name
        self.restaurantAddress = restaurant.address
        self.shelterName = profile.username
        self.shelterAddress = profile.address
        self.time = time
        self.complete = complete
        self.food = food
        self.profile = profile
        self.location = locati
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.restaurantAddress)
        {
            (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                print("Invalid location.")
                return
            }
            self.restaurantLocation = location.coordinate
        }
        
    }
    
    init(restaurant: Restaurant, time: Date, complete: Bool, food: [Food], profile: Profile)
    {
        self.restaurantName = restaurant.name
        self.restaurantAddress = restaurant.address
        self.shelterName = profile.username
        self.shelterAddress = profile.address
        self.restaurant = restaurant
        self.time = time
        self.complete = complete
        self.food = food
        self.profile = profile
        
        self.location = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.restaurantAddress)
        {
            (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                print("Invalid location.")
                return
            }
            self.restaurantLocation = location.coordinate
        }
    }
    
    init(profile: Profile)
    {
        self.restaurantName = Restaurant().name
        self.restaurantAddress = Restaurant().address
        self.shelterName = profile.username
        self.shelterAddress = profile.address
        self.restaurant = Restaurant()
        self.time = Date()
        self.complete = false
        self.food = []
        self.profile = profile
        self.location = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.restaurantAddress)
        {
            (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                print("Invalid location.")
                return
            }
            self.restaurantLocation = location.coordinate
        }
        
    }
    
    init(complete: Bool)
    {
        self.restaurantName = Restaurant().name
        self.restaurantAddress = Restaurant().address
        self.shelterName = Profile().username
        self.shelterAddress = Profile().address
        self.restaurant = Restaurant()
        self.time = Date()
        self.complete = complete
        self.food = []
        self.profile = Profile()
        self.location = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.restaurantAddress)
        {
            (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                print("Invalid location.")
                return
            }
            self.restaurantLocation = location.coordinate
        }
        
    }
    
    func getRestaurant()
    {
        let db = Firestore.firestore()
        let restaurantID = self.webID!
        
        db.collection("restaurants").document(restaurantID).getDocument
        {
            (document, error) in
            if let document = document, document.exists
            {
                self.restaurant = Restaurant(data: document.data()!, uid: restaurantID)
            }
            else
            {
                print("Document does not exist")
            }
        }
        
    }
}
