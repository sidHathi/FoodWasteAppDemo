//
//  Secondary.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import Firebase

/**
Description:
Type: SwiftUI View Class
Functionality: This class displays information about current and past pickups to a non-restaurant user
*/
struct Secondary: View {
    
    // State switch that controls whether profile pane should be displayed
    @State var showingProfile = false
    
    // State switch that controls whether app should logout user and exit view
    @State var shouldLogOut = false
    
    // This variable contains a reference to the overarching UserData object for the entire app.
    @EnvironmentObject var userData: UserData
    
    // Centerpeice of view: contains the array of all of the user's currently scheduled pickups
    @State var currentPickups: [Pickup] = []

    // Firebase Database reference
    let db = Firestore.firestore()
    
    // Array containing all of user's past pickups (populated with fake pickups for demo
    var history: [Pickup] = [Pickup(complete: false), Pickup(complete: false), Pickup(complete: false), Pickup(complete: false)]
    
    // SwiftUI stylized profile button
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }
    
    // Date Formatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Function that adds cancelation message to a Firebase pickup and sets its canceled status to true
    func cancelPickup(pickup: Pickup)
    {
        let cancelationMessage = "Pickup cancelled at \(self.dateFormatter.string(from: Date())) by \(self.userData.profile!.username)."
        self.userData.session!.db.collection("pickups").document(pickup.webID!).updateData([
            "canceled": true,
            "cancelationMessage": cancelationMessage
        ])
    }
    
    // Function that Removes all references of a pickup from the scheduled pickups array both locally and in the user's Firebase document and then adds those pickups to the user's pickups history both locally and in Firebase
    func removePickup(pickup: Pickup, cancelation: Bool)
    {
        self.userData.session!.db.collection("users").document(self.userData.session!.session!.uid).updateData([
            "scheduled": FieldValue.arrayRemove([pickup.webID])
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.userData.session!.db.collection("users").document(self.userData.session!.session!.uid).updateData([
                    "history": FieldValue.arrayUnion([pickup.webID])
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        if self.currentPickups.count > 0
                        {
                            for index in 0...(self.currentPickups.count - 1)
                            {
                                if (pickup.webID == self.currentPickups[index].webID)
                                {
                                    self.currentPickups.remove(at: index)
                                    self.cancelPickup(pickup: pickup)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Function that checks if a pickup from Firebase is new and valid. If the pickup is valid, it adds the new pickup to the pickups array. If it is a duplicate, it does nothing, if it is expired, it removes the pickup
    func managePickup(pickup: Pickup)
    {
        var duplicate = false
        let pickupTime = pickup.time
        let currentTime = Date()
        
        if (pickupTime.minutes(from: currentTime) >= -120)
        {
            pickup.getRestaurant()
            if (self.currentPickups.count > 0)
            {
                for index in 0...(self.currentPickups.count-1)
                {
                    if (pickup.webID == currentPickups[index].webID)
                    {
                        currentPickups[index] = pickup
                        duplicate = true
                    }
                }
            }
            if (!duplicate)
            {
                self.currentPickups.append(pickup)
            }
        }
        else
        {
            removePickup(pickup: pickup, cancelation: false)
        }
    }
    
    // Function that queries Firebase for the user's pickups and delegates managePickups() to deal with them.
    func getPickups()
    {
        let userID = userData.session?.session?.uid
        let pickupCollection = db.collection("pickups")
        let userCollection = db.collection("users")
        let userRef = userCollection.document(userID!)
        
        var pickupIDs: [String] = []
        var pickupData: [[String: Any]] = []
        var pickups: [Pickup] = []
        
        userRef.getDocument
        {
            (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                pickupIDs = data["scheduled"] as! [String]
                if (pickupIDs.count > 0){
                    for index in 0...(pickupIDs.count - 1)
                    {
                        var docRef = pickupCollection.document(pickupIDs[index])
                        docRef.getDocument
                        {
                            (document, error) in
                            if let document = document, document.exists
                            {
                                let data = document.data()!
                                let pickup = Pickup(data: data, id: pickupIDs[index])
                                self.managePickup(pickup: pickup)
                            }
                            else
                            {
                                print("Document does not exist")
                            }
                        }
                    }
                }
            }
            else
            {
                print("Document does not exist")
            }
        }
    }
    
    // SwiftUI view constructor
    var body: some View {
        NavigationView
        {
            ScrollView {
                VStack(alignment: .leading)
                {
                    if (userData.profile != nil){
                        if (self.currentPickups.count > 0)
                        {
                            Text("Current:")
                                .fontWeight(.heavy)
                                .font(.headline)
                                .padding(.leading)
                                .padding(.top)
                            ForEach(self.currentPickups, id: \.id)
                            {
                                pickup in
                                pickUpCard(parent: self, pickup: pickup)
                            }
                        }
                    }
                    
                    Text("Past:")
                        .fontWeight(.heavy)
                        .font(.headline)
                        .padding(.leading)
                        .padding(.top)
                    
                    ForEach(history, id: \.id)
                    {
                        pickup in
                        NavigationLink(destination: DetailView(restaurant: pickup.restaurant!)) {
                            pastPickup(pickup: pickup)
                        }
                    }
                     
                    Spacer()

                }
            }
        .navigationBarTitle("Your Pickups")
        .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: self.$showingProfile, onDismiss: {
                if (self.shouldLogOut)
                {
                    self.userData.session!.logOut()
                }
            }) {
            ProfileHost(showingSheet: self.$showingProfile, loggedOut: self.$shouldLogOut)
            .environmentObject(self.userData)
        }
        }
        .onAppear
        {
            self.getPickups()
        }
    }
}

struct Secondary_Previews: PreviewProvider {
    static var previews: some View {
        Secondary()
    }
}
