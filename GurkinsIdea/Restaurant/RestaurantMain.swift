//
//  RestaurantMain.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import Firebase

struct RestaurantMain: View {
    
    @EnvironmentObject var userData: UserData
    
    @State var showingProfile = false
    
    @State var shouldLogOut = false
    
    @State var pickups: [Pickup] = []
    
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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    func cancelPickup(pickup: Pickup)
    {
        let cancelationMessage = "Pickup cancelled at \(self.dateFormatter.string(from: Date())) by \(self.userData.restaurantProfile!.name)."
        self.userData.session!.db.collection("pickups").document(pickup.webID!).updateData([
            "canceled": true,
            "cancelationMessage": cancelationMessage
        ])
    }
    
    func removePickup(pickup: Pickup, cancel: Bool)
    {
        self.userData.session!.db.collection("users").document(self.userData.session!.session!.uid).updateData([
            "current": FieldValue.arrayRemove([pickup.webID!])
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
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
    
    func updatePickups()
    {
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
