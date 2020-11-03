//
//  Food.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/29/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import Firebase

/**
Description:
Type: DataClass
Functionality: This Dataclass stores food about food being listed by a restaurant for pickup.
*/
class Food
{
    // Instance variables
    var id = UUID()
    var name: String
    var quantity: Int
    var selectedQuantity: Int
    var start: Date
    var end: Date
    var webID: String?
    
    // Default object used in demos
    static let `empty` = Food(name: "", quantity: 0)
    
    // Main constructor: takes in JSON file converted into datamap from firebase and creates Food object
    // whose instance variables are populated based on information contained within the datamap.
    init(data: [String: Any], webID: String)
    {
        let total = data["quantity"] as! Int
        let selected = data["selected"] as! Int
        
        self.name = data["name"] as! String
        self.quantity = total-selected
        self.selectedQuantity = 0
        self.start = (data["start"] as! Timestamp).dateValue()
        self.end = (data["end"] as! Timestamp).dateValue()
        self.webID = webID
    }
    // Constructor that duplicates a food object
    init(duplicate: Food)
    {
        self.name = duplicate.name
        self.quantity = duplicate.quantity
        self.webID = duplicate.webID
        self.selectedQuantity = duplicate.selectedQuantity
        self.start = duplicate.start
        self.end = duplicate.end
        self.webID = duplicate.webID
    }
    // Constructor used to generate a food object with no Firebase counterpart
    init(name: String, quantity: Int, start: Date, end: Date)
    {
        self.name = name
        self.quantity = quantity
        self.selectedQuantity = 0
        self.start = start
        self.end = end
        self.webID = "Yos"
    }
    // Constructor used to create sample object for demos
    init(name: String, quantity: Int)
    {
        self.name = name
        self.quantity = quantity
        self.selectedQuantity = 0
        self.start = Date()
        self.end = Date(timeIntervalSinceNow: 7200)
        self.webID = "Yos"
    }
    // Default constructor
    init()
    {
        self.name = "Cheese Pizza"
        self.quantity = 2
        self.selectedQuantity = 0
        self.start = Date()
        self.end = Date(timeIntervalSinceNow: 7200)
        self.webID = "Yos"
    }
    
    // Function that changes the quantity of food
    // that's been flagged as selected by a user
    func setSelected(newQ: Int)
    {
        self.selectedQuantity = newQ
    }
    
    // Function that changes the quantity of food
    func setQ(newQ: Int)
    {
        self.quantity = newQ
    }
    
    // Function that changes the webID of the food.
    func setWebID(id: String)
    {
        self.webID = id
    }
}
