//
//  DetailView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import PartialSheet
import Firebase

struct DetailView: View {
    
    let db = Firestore.firestore()
    
    @EnvironmentObject var userData: UserData
    
    var restaurant: Restaurant
    
    @State var availableFood: [Food] = []
    
    @State var selectedFood: [Food] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showingActionSheet = false
    
    @State var pickUpTime = Date()

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image("ic_back") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                Text("Go back")
            }
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    func modifyFood()
    {
        let foodRef = db.collection("food")
        for index in (0...(self.selectedFood.count-1))
        {
            foodRef.document(selectedFood[index].webID!).updateData([
                "selected": FieldValue.increment(Int64(self.selectedFood[index].selectedQuantity))
                ])
            {
                err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
    
    
    func uploadFood()
    {
        var foodIDs: [String] = []
        var selectedMap: [String: Int] = [:]
        
        for index in (0...(self.selectedFood.count-1))
        {
            foodIDs.append(self.selectedFood[index].webID!)
            selectedMap[self.selectedFood[index].webID!] = self.selectedFood[index].selectedQuantity
        }
        
        var map: [String: Any] = [:]
        if (self.userData.session?.profile?.location != nil)
        {
            map = [
                "restaurant" : self.restaurant.uid!,
                "restaurantName" : self.restaurant.name,
                "restaurantAddress" : self.restaurant.address,
                "user" : self.userData.session!.session!.uid,
                "username" : self.userData.session!.profile!.username,
                "userAddress" : self.userData.session!.profile!.address,
                "time" : Timestamp(date: self.pickUpTime),
                "complete": false,
                "location": GeoPoint(latitude: self.userData.session!.profile!.location!.latitude, longitude: self.userData.session!.profile!.location!.longitude),
                "food": foodIDs,
                "selectedMap": selectedMap
            ]
        }
        else
        {
            map = [
                "restaurant" : self.restaurant.uid!,
                "restaurantName" : self.restaurant.name,
                "restaurantAddress" : self.restaurant.address,
                "user" : self.userData.session!.session!.uid,
                "username" : self.userData.session!.profile!.username,
                "userAddress" : self.userData.session!.profile!.address,
                "time" : Timestamp(date: self.pickUpTime),
                "complete": false,
                "location": GeoPoint(latitude: self.restaurant.coordinates.latitude, longitude: self.restaurant.coordinates.longitude),
                "food": foodIDs,
                "selectedMap": selectedMap
            ]
        }
        
        let pickupRef = db.collection("pickups")
        let usersRef = db.collection("users")
        let pickupID = UUID().uuidString
        pickupRef.document(pickupID).setData(map){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                let pickup = Pickup(data: map, id: pickupID)
                self.restaurant.addOrder(order: pickup)
                self.userData.profile!.schedulePickup(pickup: pickup)
                usersRef.document(self.restaurant.uid!).updateData([
                    "current": FieldValue.arrayUnion([pickupID])
                ])
                usersRef.document(self.userData.session!.session!.uid).updateData([
                    "scheduled": FieldValue.arrayUnion([pickupID])
                ])
            }
        }
    }
    
    
    func getFood()
    {
        self.availableFood.append(contentsOf: self.restaurant.availableFood)
        if (restaurant.aIDs != nil)
        {
            if (restaurant.aIDs!.count > 0)
            {
                let foodRef = db.collection("food")
                for index in 0...(restaurant.aIDs!.count-1)
                {
                    let docRef = foodRef.document(restaurant.aIDs![index])
                    docRef.getDocument
                    {
                        (document, error) in
                        if let document = document, document.exists
                        {
                            let map = document.data()!
                            let food = Food(data: map, webID: self.restaurant.aIDs![index])
                            self.availableFood.append(food)
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
    
    func setUpClasses()
    {
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some View {

            ScrollView {
                VStack
                {
                   // ProfileMap(coordinate: restaurant.coordinates, pin: false)
                   Image("restaurantStock")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 2)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 250)
                    CircleImage(image: Image("pagsLogo"))
                        .offset(x: 0, y: -150)
                        .padding(.bottom, -150)
                    HStack()
                    {
                        Text(restaurant.name)
                            .font(.title)
                            .bold()
                            .padding(.leading, 10)
                        Spacer()
                        
                        Button(action:{})
                        {
                            Image(systemName: "star")
                        }
                        .padding()
                        
                        Image(systemName: "phone.circle")
                            .padding()
                        Image(systemName: "car.fill")
                            .padding()
                    }
                    
                    HStack()
                    {
                        Text(restaurant.address)
                            .font(.subheadline)
                            .padding(.leading)
                            .padding(.top, 8)
                        Spacer()
                    }
                    Divider()
                    .padding()
                    HStack
                    {
                        VStack (alignment: .leading){
                            Text("Description:")
                                .font(.headline)
                                .bold()
                                .padding(.leading, 10)
                                .padding(.bottom, 10)

                            Text(restaurant.description)
                                .padding(.leading)
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    
                    Divider()
                        .padding()
                    
                    
                    if (self.availableFood.count <= 0){
                        
                        Text("No food available for pickup")
                        .foregroundColor(.red)
                        
                        Text("Request Pickup")
                            .font(.subheadline)
                            .bold()
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 80)
                            .padding(.trailing, 80)
                            .foregroundColor(Color.white.opacity(0.8))
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(10)
                            .padding()
                    }
                    else{
                        
                        HStack
                        {
                            Text("Food Available Within Next 2 Hours:")
                            .font(.headline)
                            .bold()
                            .padding(.leading, 10)
                            .padding(.bottom, 10)
                                Spacer()
                        }
                        
                        ForEach(availableFood, id: \.id)
                        {
                            food in
                            FoodModifier(food: food)
                        }
                        
                        Button(action:{
                            
                            var foodOrder: [Food] = []
                            
                            for index in (0...(self.availableFood.count-1))
                            {
                                if self.availableFood[index].selectedQuantity > 0
                                {
                                    foodOrder.append(Food(duplicate: self.availableFood[index]))
                                    //self.restaurant.availableFood[index].quantity -= self.restaurant.availableFood[index].selectedQuantity
                                    
                                }
                            }
                            //self.restaurant.availableFood.removeAll(where: {$0.quantity == 0})
                            self.selectedFood = foodOrder
                            self.showingActionSheet = true
                            
                        })
                        {
                            Text("Request Pickup")
                                .font(.subheadline)
                                .bold()
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 80)
                                .padding(.trailing, 80)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                                .cornerRadius(10)
                                .padding()
                            
                            
                        }
                        Spacer().frame(height:100)
                    }
                
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarTitle("")
            .navigationBarHidden(false)
            .partialSheet(presented: $showingActionSheet)
            {
                VStack{
                    if (self.selectedFood.count > 0){
                        VStack{
                            HStack{
                                Text("Order Summary:")
                                    .font(.headline)
                                    .bold()
                                    .padding(.leading)
                                    .padding(.top)
                                Spacer()
                            }
                            
                            List
                            {
                                ForEach (self.selectedFood, id: \.id)
                                {
                                    food in
                                    HStack{
                                        Text(food.name)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Text("(Quantity: " + String(food.selectedQuantity) + ")")
                                            .font(.subheadline)
                                            .fontWeight(.regular)
                                    }
                                    .listRowBackground(Color.black.opacity(0.05))
                                }
                                .listRowBackground(Color.black.opacity(0.05))
                            }
                            .listRowBackground(Color.black.opacity(0.05))
                            .background(Color.clear)
                            .frame(height: 100)
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .padding()
                        
                        VStack{
                            HStack{
                                Text("Select Pickup Time:")
                                    .font(.headline)
                                    .bold()
                                    .padding(.leading)
                                    .padding(.top)
                                Spacer()
                            }
                            
                            DatePicker(selection: self.$pickUpTime, displayedComponents: .hourAndMinute)
                            {
                                Text("")
                            }
                            .frame(height: 120)
                            .padding()
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .padding()
                        
                        
                        Button(action: {
                            for index in (0...(self.availableFood.count-1))
                            {
                                if self.availableFood[index].selectedQuantity > 0
                                {
                                    self.availableFood[index].quantity -= self.availableFood[index].selectedQuantity
                                }
                            }
                            self.availableFood.removeAll(where: {$0.quantity == 0})
                            
                            let pickup = Pickup(restaurant: self.restaurant, time: self.pickUpTime, complete: false, food: self.selectedFood, profile: self.userData.profile!)
                            self.restaurant.addOrder(order: pickup)
                            self.userData.profile!.schedulePickup(pickup: pickup)
                            
                            let foodRef = self.db.collection("food")
                            let userRef = self.db.collection("users")
                            let pickupRef = self.db.collection("pickup")
                            
                            var onlineFood = true
                            for index in (0...(self.selectedFood.count-1))
                            {
                                if (self.selectedFood[index].webID == nil)
                                {
                                    onlineFood = false
                                }
                            }
                            
                            if onlineFood
                            {
                                self.uploadFood()
                                self.modifyFood()
                            }
                            
                            self.presentationMode.wrappedValue.dismiss()
                            self.userData.tab = 1
                            
                        }){
                            Text("Request Pickup")
                                .font(.subheadline)
                                .bold()
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 80)
                                .padding(.trailing, 80)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                    else
                    {
                        Text("No food selected")
                            .foregroundColor(.red)
                    }
                    
                }
                
            }
            //.frame(maxHeight: 300)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear
            {
                self.setUpClasses()
                self.getFood()
            }
    }

}

struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .scaledToFit()
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(restaurant: Restaurant.withFood)
    }
}
