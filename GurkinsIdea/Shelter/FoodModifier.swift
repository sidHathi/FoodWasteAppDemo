//
//  FoodModifier.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/6/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct FoodModifier: View {
    var food: Food
    
    @State var selected: Int = 0
    
    var formatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }
    
    var body: some View {
        
        VStack(alignment: .leading)
        {
            if (self.food.quantity > 0){
                HStack{
                    VStack(alignment: .leading){
                        
                        Text(food.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        
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
                    VStack(alignment: .trailing)
                    {
                        Text("Quantity:")
                            .font(.caption)
                            .padding(.top)
                        
                        HStack
                        {
                                Button(action:{
                                    if (self.food.selectedQuantity < self.food.quantity){
                                        self.food.setSelected(newQ: (self.food.selectedQuantity + 1))
                                        self.selected += 1
                                    }
                                })
                                {
                                    Image(systemName: "plus")
                                }
                                .padding(.trailing, 8)
                                
                                Button(action:{
                                    if (self.food.selectedQuantity > 0){
                                        self.food.setSelected(newQ: (self.food.selectedQuantity - 1))
                                        self.selected -= 1
                                    }
                                })
                                {
                                    Image(systemName: "minus")
                                }
                        }
                        .padding(.trailing, 4)
                        
                        Text(String(self.selected))
                            .font(.title)
                            .bold()
                            .padding(.bottom)
                            .padding(.trailing, 4)
                    }
                    .padding(.trailing)
                }
            }
            else
            {
                ZStack{
                    VStack
                    {
                        Text("Out of stock")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    HStack{
                        VStack(alignment: .leading){
                            
                            Text(food.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .opacity(0.25)
                            .padding()
                            
                            Text("Pickup Window:")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.secondary)
                                .opacity(0.25)
                                .padding(.leading)
                            Text(formatter.string(from: food.start) + " - " + formatter.string(from: food.end))
                                .font(.subheadline)
                                .padding(.leading)
                                .padding(.bottom)
                                .opacity(0.25)
                        }
                        Spacer()
                        VStack(alignment: .trailing)
                        {
                            Text("Quantity:")
                                .font(.caption)
                                .padding(.top)
                            
                            Text(String(self.selected))
                                .font(.title)
                                .bold()
                                .padding(.bottom)
                                .padding(.trailing, 4)
                        }
                        .opacity(0.25)
                        .padding(.trailing)
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom, 16)
    }
}

struct FoodModifier_Previews: PreviewProvider {
    static var previews: some View {
        FoodModifier(food: Food())
    }
}
