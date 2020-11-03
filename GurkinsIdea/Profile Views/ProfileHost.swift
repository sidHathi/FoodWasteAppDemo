//
//  ProfileHost.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/24/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: SwiftUI class within which the a user can see and edit their profile
*/
struct ProfileHost: View {
    
    // Public state switch that stores edit state
    @Environment(\.editMode) var mode
    
    // State variable that stores data for non-restaurant user as they enter it
    @State var draftShelter = Profile()
    
    // State variable that stores data for restaurant user as they enter it
    @State var draftRestaurant = RestaurantProfile()
    
    // This variable contains a reference to the overarching UserData object for the entire app.
    @EnvironmentObject var userData: UserData
    
    // State switch that controls whether this view is visible over parent
    @Binding var showingSheet: Bool
    
    // State switch that controls whether the app should log out and exit to login screen
    @Binding var loggedOut: Bool
    
    // Function that take updates the user's profile info in Firebase based on the edits they've made
    func updateUserProfile()
    {
        if (self.userData.profile != nil)
        {
            let userDataRef = self.userData.session?.db.collection("users").document(self.userData.session!.session!.uid)
            let dataMap = draftShelter.returnDataMap()
            userDataRef?.updateData(dataMap) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
        }
        else if (self.userData.restaurantProfile != nil)
        {
            let userDataRef = self.userData.session?.db.collection("users").document(self.userData.session!.session!.uid)
            let dataMap = draftRestaurant.returnDataMap()
            userDataRef?.updateData(dataMap) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
    
    // SwiftUI view constructor class
    var body: some View {
        //ProfileSummary(user: User())
            
            VStack(alignment: .leading) {
                if (self.userData.profile != nil){
                    HStack {
                        if self.mode?.wrappedValue == .active {
                            Button("Cancel") {
                                self.draftShelter = self.userData.profile!
                                self.mode?.animation().wrappedValue = .inactive
                            }
                        }
                        
                        Spacer()
                        
                        EditButton()
                            //.padding(.trailing, 20)
                    }
                    if self.mode?.wrappedValue == .inactive {
                        ProfileSummary(showingSheet: self.$showingSheet, loggedOut: self.$loggedOut, user: userData.profile!).environmentObject(self.userData.session!)
                    } else {
                        ProfileEditor(user: $draftShelter)
                            .onAppear {
                                self.draftShelter = self.userData.profile!
                            }
                            .onDisappear {
                                self.userData.profile = self.draftShelter
                                self.updateUserProfile()
                            }
                    }
                }
                else
                {
                    HStack {
                            if self.mode?.wrappedValue == .active {
                                Button("Cancel") {
                                    self.draftRestaurant = self.userData.restaurantProfile!
                                    self.mode?.animation().wrappedValue = .inactive
                                }
                            }
                            
                            Spacer()
                            
                            EditButton()
                                //.padding(.trailing, 20)
                        }
                        if self.mode?.wrappedValue == .inactive {
                            RestaurantProfileSummary(showingSheet: self.$showingSheet, loggedOut: self.$loggedOut, user: userData.restaurantProfile!).environmentObject(self.userData.session!)
                            .foregroundColor(.primary)
                        } else {
                            RestaurantEditor(user: $draftRestaurant)
                            .foregroundColor(.primary)
                                .onAppear {
                                    self.draftRestaurant = self.userData.restaurantProfile!
                                }
                                .onDisappear {
                                    self.userData.restaurantProfile = self.draftRestaurant
                                    self.updateUserProfile()
                                }
                        }
                }
            }
            .padding()
                
            
        
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
