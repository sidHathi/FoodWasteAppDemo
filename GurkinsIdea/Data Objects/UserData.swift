//
//  UserData.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/26/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import SwiftUI

final class UserData: ObservableObject
{
    @Published var profile: Profile?
    @Published var restaurantProfile: RestaurantProfile?
    @Published var user: User?
    @Published var session: FirebaseSession?
    @Published var tab = 0
    
    init(profile: Profile, user: User, session: FirebaseSession)
    {
        self.profile = profile
        self.user = user
        self.session = session
    }
    init(rProfile: RestaurantProfile, user: User, session: FirebaseSession)
    {
        self.restaurantProfile = rProfile
        self.user = user
        self.session = session
    }
    init()
    {
        self.user = nil
        self.session = nil
    }
}
