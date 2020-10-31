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

class Profile
{
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
    
    static let `default` = Profile()
    
    func returnDataMap() -> [String: Any]
    {
        return ["name": self.username,
                "address": self.address,
                "capacity": self.people
                ]
    }
    
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
    
    func schedulePickup(pickup: Pickup)
    {
        self.scheduled.append(pickup)
    }
    
    func setLocation(location: CLLocationCoordinate2D)
    {
        self.location = location
    }
}
