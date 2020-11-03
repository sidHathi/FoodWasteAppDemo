//
//  ContentView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/18/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation
import Firebase

/**
Description:
Type: SwiftUI View Class
Functionality: This class creates the main UI view (map + browse) for a non-restaurant user. It centers around an array of restaurant's in the user's area which it pulls from Firebase. The majority of the view is composed of visual respresentations of these restaurants and navigation links that the users can use to pull up a more detailed page on a particular restaurant
*/
struct Main: View {
    
    // Centerpeice of view: this state Array contains informatino regarding every restaurant loaded from Firebase
    @State var restaurants: [Restaurant] = []
    
    // This view contains links that transition to a DetailView view for a particular restaurant. The following state variable records the index of the restaurant to be displayed in the DetailView.
    @State var selected = 0
    
    // This variable contains a reference to the overarching UserData object for the entire app.
    @EnvironmentObject var userData: UserData
    
    // This view has two states: The first is its default state where it displays the map and browse card. The second is a full screen DetailView for a particular restaurant. This must be the case because the links in the map cannot be NavigationLinks. As a result, this state switch is used to show the appropriate detail in this Main view instead of navigating to a different DetailView for some restaurant.
    @State var map: Bool;
    
    // OBSOLETE
    @State private var switching = true
    
    // OBSOLETE
    @State var isNavigationBarHidden: Bool = true
    
    // OBSOLETE
    @State var selection: Int? = nil
    
    // State switch that controls whether profile pane is displayed over view context
    @State var showingProfile = false
    
    // State switch that controls whether the app should log out a user and exit back to the login screen
    @State var shouldLogOut = false
    
    // OBSOLETE
    @State var title: String = "Near You"
    
    // OBSOLETE
    static var segued = false
    
    // Firebase database reference
    let db = Firestore.firestore()
    
    // Function that queries Firebase for all the restaurants within its Database (will change to restaurants in an area when app scales) and stores them in the restaurants array
    func getRestaurants()
    {
        var restaurants: [Restaurant] = []
        let indexRef = db.collection("restaurants").document("index")
        indexRef.getDocument
        {
            (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let ids = data["restaurants"] as! [String]
                for index in 0...(ids.count-1)
                {
                    let restRef = self.db.collection("users").document(ids[index])
                    restRef.getDocument
                    {
                        (document, error) in
                        if let document = document, document.exists
                        {
                            let map = document.data()!
                            restaurants.append(Restaurant(data: map, uid: ids[index]))
                            if (self.restaurants.count > 0) && (restaurants.count > 0)
                            {
                                for index1 in 0...(restaurants.count-1)
                                {
                                    var duplicate = false
                                    for index2 in 0...(self.restaurants.count-1)
                                    {
                                        if (self.restaurants[index2] == restaurants[index1])
                                        {
                                            self.restaurants[index2] = restaurants[index1]
                                            duplicate = true
                                        }
                                    }
                                    if (!duplicate)
                                    {
                                        self.restaurants.append(restaurants[index1])
                                    }
                                }
                            }
                            else{
                                self.restaurants.append(Restaurant(data: map, uid: ids[index]))
                            }
                        }
                        else
                        {
                            print("Document does not exist")
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
    
    // Stylized SwiftUI profile button
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
    
    // SwiftUI view constructor
    var body: some View {
        VStack
        {
            // Implementation of map state switch - this is how the view transitions between the default view and a Restaurant detail view when a click is register within the MapView
            if (map)
            {
                NavigationView {
                    ZStack{
                        VStack{
                            MapView(restaurants: self.restaurants, parent: self)
                            .edgesIgnoringSafeArea(.all)
                            //.frame(height: geometry.size.height)
                            Spacer()
                        }
                    
                        SlideOverCard
                        {
                            ScrollView{
                                VStack
                                {
                                    MainBrowseView(restaurants: self.restaurants)
                                    
                                    Spacer()
                                    
                                }
                            }
                        }
                        
                    }
                    .sheet(isPresented: self.$showingProfile, onDismiss: {
                        if (self.shouldLogOut)
                        {
                            self.userData.session!.logOut()
                        }
                    }) {
                        ProfileHost(showingSheet: self.$showingProfile, loggedOut: self.$shouldLogOut).environmentObject(self.userData)
                    }
                    .navigationBarItems(trailing: self.profileButton)
                    
                    
                    /*
                    BrowseView(restaurants: self.restaurants)
                        .cornerRadius(20)
                        .frame(height: geometry.size.height*1/2)
                        .offset(x: 0, y: -40)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .shadow(radius: 20)
                        .sheet(isPresented: self.$showingProfile, onDismiss: {
                            if (self.shouldLogOut)
                            {
                                self.userData.session!.logOut()
                            }
                        }) {
                            ProfileHost(showingSheet: self.$showingProfile, loggedOut: self.$shouldLogOut).environmentObject(self.userData)
                        }
                    */
                }
                
            }
            else
            {
                NavigationView{
                    DetailView(restaurant: restaurants[self.selected]).environmentObject(self.userData)
                        .navigationBarItems(leading:
                            Button(action: {self.map.toggle()})
                            {
                                Image(systemName: "chevron.left")
                            }
                        )
                }
                
            }
        }
        .onAppear
        {
            self.getRestaurants()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Main(map: true)
    }
}
