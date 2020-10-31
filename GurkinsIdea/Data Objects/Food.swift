//
//  Food.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/29/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import Firebase

class Food
{
    var id = UUID()
    var name: String
    var quantity: Int
    var selectedQuantity: Int
    var start: Date
    var end: Date
    var webID: String?
    
    static let `empty` = Food(name: "", quantity: 0)
    
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
    init(name: String, quantity: Int, start: Date, end: Date)
    {
        self.name = name
        self.quantity = quantity
        self.selectedQuantity = 0
        self.start = start
        self.end = end
        self.webID = "Yos"
    }
    init(name: String, quantity: Int)
    {
        self.name = name
        self.quantity = quantity
        self.selectedQuantity = 0
        self.start = Date()
        self.end = Date(timeIntervalSinceNow: 7200)
        self.webID = "Yos"
    }
    
    init()
    {
        self.name = "Cheese Pizza"
        self.quantity = 2
        self.selectedQuantity = 0
        self.start = Date()
        self.end = Date(timeIntervalSinceNow: 7200)
        self.webID = "Yos"
    }
    
    func setSelected(newQ: Int)
    {
        self.selectedQuantity = newQ
    }
    
    func setQ(newQ: Int)
    {
        self.quantity = newQ
    }
    
    func setWebID(id: String)
    {
        self.webID = id
    }
}
