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

struct Main: View {
    @State var selected = 0
    
    @EnvironmentObject var userData: UserData
    
    @State var map: Bool;
    
    @State private var switching = true
    
    @State var isNavigationBarHidden: Bool = true
    
    @State var selection: Int? = nil
    
    @State var showingProfile = false
    
    @State var shouldLogOut = false
    
    @State var title: String = "Near You"
    
    static var segued = false
    
    let db = Firestore.firestore()
    
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
    
    @State var restaurants: [Restaurant] = []
    
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
    
    var body: some View {
        VStack
        {
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
