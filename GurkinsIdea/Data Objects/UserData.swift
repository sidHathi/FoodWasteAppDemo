//
//  UserData.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/26/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import SwiftUI


/**
 Description:
 Type: DataClass
 Functionality: This class provides an overarching datastructure within which
 all information regarding the current user including their profile information,
 location within the app, and references to their current database session can
 be stored and accessed. Such an object is generated for each user and passed
 between view Controllers.
 */
final class UserData: ObservableObject
{
    // instance variables - viewable and accessible anywhere
    @Published var profile: Profile?
    @Published var restaurantProfile: RestaurantProfile?
    @Published var user: User?
    @Published var session: FirebaseSession?
    @Published var tab = 0
    
    // Constructor used to generate UserData object for someone using app to pick up food (not restaurants)
    init(profile: Profile, user: User, session: FirebaseSession)
    {
        self.profile = profile
        self.user = user
        self.session = session
    }
    // Constructor used to generate UserData object for restaurants
    init(rProfile: RestaurantProfile, user: User, session: FirebaseSession)
    {
        self.restaurantProfile = rProfile
        self.user = user
        self.session = session
    }
    // Default constructor
    init()
    {
        self.user = nil
        self.session = nil
    }
}
