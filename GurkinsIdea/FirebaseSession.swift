//
//  FirebaseSession.swift
//  TODO
//
//  Created by Sebastian Esser on 9/18/19.
//  Copyright © 2019 Sebastian Esser. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

/**
Description:
Type: DataClass
Functionality: This class stores and executes all information related to the user's current Firebase session.
 This includes keeping track of the user's information, login state and database references, and handling
 all authentication and setup functionality required for the app to interface with Firebase.
*/
class FirebaseSession: ObservableObject {
    
    // The following variables store publicly accessible information about the User's authentication state and profile data required to run the app.
    @Published var session: User?
    @Published var isLoggedIn: Bool?
    @Published var profile: Profile? = nil
    @Published var restaurantProfile: RestaurantProfile? = nil
    @Published var userDataExists: Bool?
    
    // Default user image for demo purposes
    @State var profileImage = UIImage(named: "yosAvatar")

    // Firebase References
    var db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var usersRef: CollectionReference? = nil
    var userDocRef: DocumentReference? = nil
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference()
    
    
    // Starts Firebase authentication session and figures out whether the user is logged in on the device. If the user is logged, in this method retreives their profile information and adds it to local storage. If not, it updates the state variables that indicate control the login view controller, thereby prompting the user to login.
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, displayName: user.displayName, email: user.email)
                self.isLoggedIn = true
                self.usersRef = self.db.collection("users")
                if (self.usersRef != nil && self.session != nil)
                {
                    self.userDocRef = self.usersRef?.document(self.session!.uid)
                    self.userDocRef?.getDocument{
                        (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            print("Document data: \(dataDescription)")
                            
                            let imageRef = self.storage.reference(forURL: document.data()!["imageURL"] as! String)
                            
                            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                              if let error = error {
                                // Uh-oh, an error occurred!
                              } else {
                                // Data for "images/island.jpg" is returned
                                self.profileImage = UIImage(data: data!)
                              }
                            }
                            if (document.data()!["restaurant"] as! Bool)
                            {
                                var restaurantProfile = RestaurantProfile(data: document.data()!)
                                self.restaurantProfile = restaurantProfile
                            }
                            else
                            {
                                let profile = Profile(data: document.data()!, webID: (self.session?.uid)!, image: Image(uiImage: self.profileImage!))
                                
                                self.profile = profile
                            }
                            
                            self.userDataExists = true
                        } else {
                            print("Document does not exist")
                            self.userDataExists = false
                        }
                    }
                }
            } else {
                self.isLoggedIn = false
                self.session = nil
            }
        }
    }
    
    // Function that logs the user in based on their inputs for email and password
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    // Function that logs the user out and updates necessary instance variables
    func logOut() {
        try! Auth.auth().signOut()
        self.isLoggedIn = false
        self.session = nil
        self.profile = nil
        self.usersRef = nil
        self.userDataExists = nil
    }
    
    // Function that signs up a new user
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
}
