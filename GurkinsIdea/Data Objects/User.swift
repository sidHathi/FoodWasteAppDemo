//
//  User.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/15/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation

/**
Description:
Type: DataClass
Functionality: This class is used to store basic authentication info for Firebase sessions
*/
class User {
    var uid: String
    var email: String?
    var displayName: String?
    //var newUser: Bool

    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        //self.newUser = newUser
    }

}
