//
//  Secondary.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import Firebase

struct Secondary: View {
    
    @State var showingProfile = false
    @State var shouldLogOut = false
    @EnvironmentObject var userData: UserData
    
    @State var currentPickups: [Pickup] = []

    let db = Firestore.firestore()
    
    var history: [Pickup] = [Pickup(complete: false), Pickup(complete: false), Pickup(complete: false), Pickup(complete: false)]
    
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    func cancelPickup(pickup: Pickup)
    {
        let cancelationMessage = "Pickup cancelled at \(self.dateFormatter.string(from: Date())) by \(self.userData.profile!.username)."
        self.userData.session!.db.collection("pickups").document(pickup.webID!).updateData([
            "canceled": true,
            "cancelationMessage": cancelationMessage
        ])
    }
    
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
