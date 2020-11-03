//
//  FoodItem.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/25/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: This class creates the UI card used within Restaurant Secondary view to display food currently on Restaurant's menu
*/
struct FoodItem: View {
    
    // Reference to RestaurantSecondary variable eddittingFood
    @Binding var editting: Bool
    // Reference to parent: RestaurantSecondary
    var parent: RestaurantSecondary
    
    // Food object being displayed
    var food: Food
    // Obsolete variable used in older version of app
    var hasUsers: Bool
    // Obsolete variable used in older version of app
    var users: [Profile]?
    
    // Date foramtter
    var formatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }
    
    // SwiftUI view constructor
    var body: some View {
        ZStack{
            VStack{
                if (food.quantity < 1)
                {
                    Spacer()
                    Text("Reserved")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Spacer()
                }
                else if (editting){
                    HStack{
                        Spacer()
                        Button(action: {})
                        {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(Image.Scale.large)
                        }
                        .padding(.trailing, 4)
                        Button(action: {
                            self.parent.removeFood(food: self.food)
                        })
                        {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .imageScale(Image.Scale.large)
                        }
                    }
                    .offset(x: 0, y: 0)

                    Spacer()
                }
            }
            VStack(alignment: .leading)
            {
                
                if (hasUsers)
                {
                    VStack(alignment: .leading)
                    {
                        HStack
                        {
                            NumberImage(image: Image("shelterGeneric"))
                                .padding(.leading)
                                .padding(.top, 5)
                            NumberImage(image: Image("shelterGeneric"))
                                .padding(.leading, 10)
                                .padding(.top, 5)
                        }
                        Divider()
                            .padding(.leading)
                            .padding(.trailing)
                    }
                }
                HStack{
                    if (self.food.quantity > 0){
                        VStack(alignment: .leading){
                            if (hasUsers){
                                Text(food.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom)
                                    .padding(.leading)
                            }
                            else
                            {
                                Text(food.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                            }
                            Text("Pickup Window:")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.secondary)
                                .padding(.leading)
                            Text(formatter.string(from: food.start) + " - " + formatter.string(from: food.end))
                                .font(.subheadline)
                                .padding(.leading)
                                .padding(.bottom)
                        }
                        Spacer()
                        VStack
                        {
                            Text("Quantity:")
                                .font(.caption)
                                .padding(.trailing)
                            Text(String(food.quantity))
                                .font(.title)
                                .bold()
                        }
                    }
                    else
                    {
                        VStack(alignment: .leading){
                            if (hasUsers){
                                Text(food.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom)
                                    .padding(.leading)
                            }
                            else
                            {
                                Text(food.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                            }
                            Text("Pickup Window:")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.secondary)
                                .padding(.leading)
                            Text(formatter.string(from: food.start) + " - " + formatter.string(from: food.end))
                                .font(.subheadline)
                                .padding(.leading)
                                .padding(.bottom)
                        }
                        .opacity(0.25)
                        Spacer()
                        VStack
                        {
                            Text("Available:")
                                .font(.caption)
                                .padding(.trailing)
                            Text(String(food.quantity))
                                .font(.title)
                                .bold()
                        }
                        .opacity(0.25)
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

/**
Description:
 OBSOLETE
Type: SwiftUI View Class
Functionality: This class creates a neumorphic profile image with number overlay. Not used.
*/
struct NumberImage: View
{
    var image: Image
    
    var body: some View
    {
        ZStack
        {
            image
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .scaledToFit()
                .shadow(radius: 8)
            Text("1")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black.opacity(0.3))
                .clipShape(Circle())
        }
    }
}

struct FoodItem_Previews: PreviewProvider {
    static var previews: some View {
        FoodItem(editting: .constant(true), parent: RestaurantSecondary(), food: Food(), hasUsers: true)
    }
}
