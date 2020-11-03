//
//  User.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/24/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

/**
Description:
Type: DataClass
Functionality: This class is where the vast body of information regarding non-restaurant users
 is stored. This data includes. Objects of this class are stored within the app and used by
 all the view controllers to determine what the user should see.
*/
class Profile
{
    // Instance variables
    var id = UUID()
    var username: String
    var prefersNotifications: Bool
    var favorites: [Restaurant]
    @State var scheduled: [Pickup]
    var history: [Pickup]
    var address: String
    var people: Double
    var imageName: String = "yosAvatar"
    var image: Image
    var location: CLLocationCoordinate2D?
    var webID: String?
    
    // Default profile object
    static let `default` = Profile()
    
    // Function that generates a Firebase-formatted dataMap based on the information stored within
    // the object's instance variables. Used to store new user profiles on Firebase.
    func returnDataMap() -> [String: Any]
    {
        return ["name": self.username,
                "address": self.address,
                "capacity": self.people
                ]
    }
    
    // Main constructor: takes in JSON file converted into datamap from firebase and creates Profile object
    // whose instance variables are populated based on information contained within the datamap.
    init(data: [String: Any], webID: String, image: Image)
    {
        self.webID = webID
        self.username = data["name"] as! String
        self.prefersNotifications = true
        self.favorites = [Restaurant()]
        self.scheduled = []
        self.history = []
        self.address = data["address"] as! String
        self.people = Double(data["capacity"] as! Int)
        self.image = image
    }
    
    // Constructor used to populate Profile from local data
    init(username: String, prefersNotifications: Bool, favorites: [Restaurant], scheduled: [Pickup], history: [Pickup], address: String, people: Double, image: UIImage)
    {
        self.username = username
        self.prefersNotifications = prefersNotifications
        self.favorites = favorites
        self.scheduled = scheduled
        self.history = history
        self.address = address
        self.people = people
        self.image = Image(uiImage: image)
    }
    
    // Default constructor
    init()
    {
        self.username = "chosenYos"
        self.prefersNotifications = true
        self.favorites = [Restaurant(), Restaurant(), Restaurant(), Restaurant()]
        self.scheduled = []
        self.history = []
        self.address = "14050 1st Ave NE, Seattle, WA 98125"
        self.people = 100
        self.image = Image(self.imageName)
    }
    
    // Function that adds new pickups to array of scheduled pickups
    func schedulePickup(pickup: Pickup)
    {
        self.scheduled.append(pickup)
    }
    
    // Function that stores the user's location based on the
    // actual recorded location of the user
    func setLocation(location: CLLocationCoordinate2D)
    {
        self.location = location
    }
}
