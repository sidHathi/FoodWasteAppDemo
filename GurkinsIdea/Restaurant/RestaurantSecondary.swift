//
//  RestaurantSecondary.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/25/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import Firebase

/**
Description:
Type: SwiftUI View Class
Functionality: This class contains builds and populates the view used by the Restaurant to manage and add food for pickup
*/
struct RestaurantSecondary: View {
    
    // This variable contains a reference to the overarching UserData object for the entire app.
    @EnvironmentObject var userData: UserData
    
    // State switch that controls whether view is in edit mode
    @State var editingFood = false
    // State variable that stores information regarding new food objects
    @State var newFood = Food(name: "", quantity: 0)
    // State variable used in the textinput where the user names new food
    @State var newFoodName = ""
    // State variable used for the counter used by the user to add food
    @State var newFoodQuantity = 0
    // State variable that controls whether the profile view is visible
    @State var showingProfile = false
    // State variable that determines whether the view should quit and log out
    @State var shouldLogOut = false
    // State array that contains all the food currently offered by the restaurant
    @State var food: [Food] = []
    
    // Database reference
    let db = Firestore.firestore()
    
    // SwiftUI stylized profile button
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
        }
    }
    
    // Function that checks if a certain food object is within its expiration date
    func isFoodAvailable(food: Food) -> Bool
    {
        if (food.end.minutes(from: Date()) < 0)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    // Function that handles food objects created from new Firebase queries. Each query pulls down every food object in the restaurant's current menu. This function adds the ones that aren't duplicates (new ones) to the local food array, and removes the expired ones.
    func manageFood(food: Food)
    {
        if (isFoodAvailable(food: food)){
            var duplicate = false
            if (self.food.count > 0){
                for index in 0...(self.food.count-1)
                {
                    if (self.food[index].webID! == food.webID!)
                    {
                        duplicate = true
                    }
                }
                if (!duplicate)
                {
                    self.food.append(food)
                }
            }
            else
            {
                self.food.append(food)
            }
        }
        else
        {
            self.removeFood(food: food)
        }
    }
    
    // Function that queries Firebase for Restaurant's menu and adds it to local State arrays used to display the menu back to the Restaurant.
    func getAvailableFood()
    {
        let dbRef = db.collection("food")
        if (self.userData.session?.restaurantProfile!.aIDs != nil){
            let ids = self.userData.session!.restaurantProfile!.aIDs!
            if (ids.count > 0){
                for index in 0...(ids.count-1)
                {
                    let docRef = dbRef.document(ids[index])
                    docRef.getDocument
                    {
                        (document, error) in
                        if let document = document, document.exists {
                            let map = document.data()!
                            let newFood = Food(data: map, webID: ids[index])
                            self.manageFood(food: newFood)
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
            self.userData.session!.restaurantProfile!.availableFood = food
        }
    }
     
    // Deprecated function for getting available food.
    /*
    var availableFood: [Food]
    {
        if (self.userData.session!.restaurantProfile!.aIDs != nil)
        {
            let dbRef = db.collection("food")
            var food: [Food] = []
            let ids = self.userData.session!.restaurantProfile!.aIDs!
            if (ids.count > 0){
                for index in 0...(ids.count-1)
                {
                    let docRef = dbRef.document(ids[index])
                    docRef.getDocument
                    {
                        (document, error) in
                        if let document = document, document.exists {
                            let map = document.data()!
                            var duplicate = false
                            let newFood = Food(data: map, webID: ids[index])
                            if (self.food.count > 0){
                                for index in 0...(self.food.count-1)
                                {
                                    if (self.food[index].webID! == newFood.webID!)
                                    {
                                        duplicate = true
                                    }
                                }
                                if (!duplicate)
                                {
                                    food.append(newFood)
                                    self.food.append(newFood)
                                }
                            }
                            else
                            {
                                food.append(newFood)
                                self.food.append(newFood)
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
            self.userData.session!.restaurantProfile!.availableFood = food
            //self.food.append(contentsOf: food)
            return food
        }
        return []
    }*/
    
    // Function that removes the specified food object from the local array of food objects.
    func removeFood(food: Food)
    {
        if (food.webID != nil){
            print(food.webID!)
            self.userData.session!.db.collection("users").document(self.userData.session!.session!.uid).updateData(["availableFood": FieldValue.arrayRemove([food.webID!])]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    if (self.food.count > 0)
                    {
                        for index in 0...(self.food.count-1)
                        {
                            if (self.food[index].id == food.id)
                            {
                                self.food.remove(at: index)
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Function that adds the new food object posted by the restaurant to the Restaurant's menu stored on Firebase.
    func addFood()
    {
        
        let id = UUID().uuidString
        newFood.setWebID(id: id)
        let start = Timestamp(date: newFood.start)
        let end = Timestamp(date: newFood.end)
        let docData: [String: Any] = [
            "name" : self.newFood.name,
            "quantity" : self.newFood.quantity,
            "start" : start,
            "end" : end,
            "restaurantID": self.userData.session!.session!.uid,
            "selected": 0
        ]
        
        db.collection("food").document(id).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        db.collection("users").document(self.userData.session!.session!.uid).updateData([
            "availableFood": FieldValue.arrayUnion([id])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        food.append(contentsOf: [newFood])
        self.newFood = Food(name: "", quantity: 0)
    }
    
    // SwiftUI View Constructor
    var body: some View {
        NavigationView{
            ScrollView{
                VStack
                {
                    FoodCard(foodName: self.$newFoodName, quantity: self.$newFoodQuantity, food: self.$newFood, parent: self)
                    Divider()
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                    
                    HStack
                    {
                        Text("Current Menu:")
                            .font(.headline)
                            .bold()
                            .padding(.leading)
                        Spacer()
                        Button(action:{
                            self.editingFood.toggle()
                        })
                        {
                            if (self.editingFood){
                                Text("Done")
                            }
                            else{
                                Text("Edit")
                            }
                        }
                        .padding(.trailing)
                    }.padding(.bottom)
                    
                    
                    if (self.food.count < 1){
                        Spacer()
                        Text("There are no items currently listed in your public menu.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(40)
                    }
                    
                    if (self.food.count > 0)
                    {
                        ForEach(self.food, id: \.id)
                        {
                            food in
                            FoodItem(editting: self.$editingFood, parent: self, food: food, hasUsers: false)
                                .padding(.leading)
                                .padding(.trailing)
                                .padding(.top, 8)
                                .padding(.bottom, 8)
                        }
                    }
                    /*
                    FoodItem(food: Food(), hasUsers: true)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    
                    FoodItem(food: Food(), hasUsers: false)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    
                    FoodItem(food: Food(), hasUsers: false)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 8)
                    .padding(.bottom, 8)*/
                    
                    Spacer()
                }
                .navigationBarTitle("Available Food")
                .navigationBarItems(trailing: profileButton)
                .onAppear
                {
                    self.getAvailableFood()
                }
                .sheet(isPresented: self.$showingProfile, onDismiss: {
                    
                    if (self.shouldLogOut)
                    {
                        self.userData.session!.logOut()
                    }
                }) {
                    ProfileHost(showingSheet: self.$showingProfile, loggedOut: self.$shouldLogOut).environmentObject(self.userData)
                }
            }
        }
        
    }
}

struct RestaurantSecondary_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantSecondary().environmentObject(UserData())
    }
}
