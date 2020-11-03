//
//  RestaurantMain.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import Firebase

/**
Description:
Type: SwiftUI View Class
Functionality: This class contains builds and populates the main view seen by restaurants using the app.
*/
struct RestaurantMain: View {
    
    // This variable contains a reference to the overarching UserData object for the entire app.
    @EnvironmentObject var userData: UserData
    
    // State variable that determines whether the profile view is displayed
    @State var showingProfile = false
    
    // State variable that determines wether logOut should be called
    @State var shouldLogOut = false
    
    // State variable that populates with pickups from Firebase in real time
    @State var pickups: [Pickup] = []
    
    // SwiftUI sylized profile Button
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .accessibility(label: Text("User Profile"))
        }
        .padding()
        .background(Color(UIColor.systemBackground).opacity(0.75))
        .font(.title)
        .clipShape(Circle())
    }
    
    // Dateformatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Function that updates a Pickup's canceled status on Firebase as true
    func cancelPickup(pickup: Pickup)
    {
        let cancelationMessage = "Pickup cancelled at \(self.dateFormatter.string(from: Date())) by \(self.userData.restaurantProfile!.name)."
        self.userData.session!.db.collection("pickups").document(pickup.webID!).updateData([
            "canceled": true,
            "cancelationMessage": cancelationMessage
        ])
    }
    
    // Function that removes all traces of a certain pickup object from both Firebase and local storage
    func removePickup(pickup: Pickup, cancel: Bool)
    {
        // Firebase query
        self.userData.session!.db.collection("users").document(self.userData.session!.session!.uid).updateData([
            "current": FieldValue.arrayRemove([pickup.webID!])
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                // local removal in closure
                if (self.pickups.count > 0)
                {
                    for index in 0...(self.pickups.count-1)
                    {
                        if (self.pickups[index].webID == pickup.webID)
                        {
                            self.pickups.remove(at: index)
                            break
                        }
                    }
                }
                if (self.userData.restaurantProfile!.cPIDs!.count > 0)
                {
                    for index in 0...(self.userData.restaurantProfile!.cPIDs!.count - 1)
                    {
                        self.userData.restaurantProfile!.cPIDs!.remove(at: index)
                        break
                    }
                }
                if (!cancel){
                    // Updates pickup history of restaurant on Firebase
                    self.userData.session!.db.collection("users").document(self.userData.session!.session!.uid).updateData([
                        "history": FieldValue.arrayUnion([pickup.webID!])
                    ]){ err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
                else
                {
                    self.cancelPickup(pickup: pickup)
                }
            }
        }
    }
    
    // Function that gets pickups from Firebase and updates local pickups array
    func updatePickups()
    {
        // Loops through locally stored pickup IDs within user's RestaurantProfile and gets them from Firebase
        if (self.userData.session?.restaurantProfile?.cPIDs != nil)
        {
            if self.userData.session!.restaurantProfile!.cPIDs!.count > 0{
                for index in 0...(self.userData.session!.restaurantProfile!.cPIDs!.count - 1){
                    self.userData.session!.db.collection("pickups").document(self.userData.session!.restaurantProfile!.cPIDs![index]).getDocument{
                        (document, error)  in
                        
                        if let document = document, document.exists
                        {
                            let dataMap = document.data()!
                            let newPickup = Pickup(data: dataMap, id: self.userData.session!.restaurantProfile!.cPIDs![index])
                            if (self.pickups.count > 0)
                            {
                                var duplicate = false
                                for index in (0...(self.pickups.count-1))
                                {
                                    if (self.pickups[index].webID == newPickup.webID)
                                    {
                                        self.pickups[index] = newPickup
                                        duplicate = true
                                    }
                                }
                                if (!duplicate)
                                {
                                    self.pickups.append(newPickup)
                                }
                            }
                            else
                            {
                                self.pickups.append(newPickup)
                            }
                        }
                        else
                        {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
    
    // SwiftUI view constructor
    var body: some View {
        NavigationView
        {
            ZStack
            {
                RestaurantMapView(pickups: .constant([Pickup(complete: false)]))
                    .edgesIgnoringSafeArea(.all)
                SlideOverCard
                {
                    VStack (alignment: .leading)
                    {
                        Text("Scheduled Pickups:")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.leading)
                        ScrollView{
                            VStack (alignment: .leading)
                            {
                                if (self.pickups.count > 0){
                                    ForEach(self.pickups, id:\.id)
                                    {
                                        pickup in
                                        UpcomingList(parent: self, pickup: pickup)
                                        .padding(.bottom, 8)
                                    }
                                }
                                else
                                {
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        Text("No Scheduled Pickups")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: self.$showingProfile, onDismiss: {
                
                if (self.shouldLogOut)
                {
                    self.userData.session!.logOut()
                }
            }) {
                ProfileHost(showingSheet: self.$showingProfile, loggedOut: self.$shouldLogOut).environmentObject(self.userData)
                
            }
            .navigationBarItems(trailing: self.profileButton)
        }
        .onAppear{
            self.updatePickups()
        }
    }
}

struct RestaurantMain_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMain().environmentObject(UserData())
    }
}
