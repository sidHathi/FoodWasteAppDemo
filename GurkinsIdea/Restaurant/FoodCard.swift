//
//  FoodCard.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/25/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: This class creates the UI card used within Restaurant Secondary view to add new food to menu
*/
struct FoodCard: View {
    
    // Reference to the string newFoodName within RestaurantSecondary
    @Binding var foodName: String
    
    // Reference to the integer quantity within RestaurantSecondary
    @Binding var quantity: Int
    
    // Reference to the actual food object within RestaurantSecondary
    @Binding var food: Food
    
    // String displayed in card's label
    @State var qString: String = "0"
    
    // State variable that controls whether card is expanded
    @State var expanded: Bool = false
    
    // Stat variable that contains current time
    @State var currentDate = Date()
    
    // Reference to parent
    var parent: RestaurantSecondary
    
    // SwiftUI view constructor
    var body: some View {
        VStack(alignment: .leading)
        {
            if (expanded){
                HStack{
                    Text("Add Food")
                        .font(.title)
                        .bold()
                        .padding(.leading)
                        .padding(.top)
                    Spacer()
                    HStack
                    {
                        Button(action:{
                            self.food.quantity += 1
                            self.qString = String(self.food.quantity)
                        })
                        {
                            Image(systemName: "plus")
                        }
                        .padding(.leading, 5)
                        
                        
                        Button(action:{
                            if (self.food.quantity > 0)
                            {
                                self.food.quantity -= 1
                                self.qString = String(self.food.quantity)
                            }
                        })
                        {
                            Image(systemName: "minus")
                        }
                        .padding(.leading, 5)
                        
                        VStack{
                            Text("Quantity:")
                                .font(.caption)
                                .padding(.trailing)
                            Text(qString)
                                .font(.title)
                                .bold()
                        }
                        
                    }
                    .padding(.trailing)
                    .padding(.top)
                    
                }
                HStack
                {
                    TextField("Name/Description of Food", text: $food.name)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                    Spacer()
                    
                }
                Divider().padding(.leading).padding(.trailing)
                HStack{
                    Text("Pickup Window:")
                        .font(.headline)
                        .bold()
                        .padding()
                    Spacer()
                }
                VStack(alignment: .leading){
                    Text("Start Time:")
                        .font(.subheadline)
                        .padding(.leading, 10)
                    ExpandingDatePicker(date: self.$food.start)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
                VStack(alignment: .leading){
                    Text("End Time:")
                        .font(.subheadline)
                        .padding(.leading, 10)
                    ExpandingDatePicker(date: self.$food.end)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
                
                HStack
                {
                    Spacer()
                    Button(action:{
                        self.parent.addFood()
                        self.food = Food(name: "", quantity: 0)
                        self.qString = "0"
                        self.expanded = false
                        self.foodName = ""
                    }){
                        Text("Confirm")
                            .font(.subheadline)
                            .bold()
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .background(Color.primary)
                            .cornerRadius(10)
                            .padding(5)
                    }
                    Button(action:{
                        self.expanded = false
                    }){
                        Text("Cancel")
                            .font(.subheadline)
                            .bold()
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .foregroundColor(.primary)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(5)
                    }
                    Spacer()
                }
                .padding(.bottom)
            }
            else
            {
                Button(action:{
                    self.expanded = true
                }){
                    HStack
                    {
                        Text("Add Food")
                            .padding(.leading)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .padding(.trailing)
                    }
                }
                .padding(10)
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
        
    }
}

struct FoodCard_Previews: PreviewProvider {
    static var previews: some View {
        FoodCard(foodName: .constant(""), quantity: .constant(0), food: .constant(Food.empty), parent: RestaurantSecondary())
    }
}
