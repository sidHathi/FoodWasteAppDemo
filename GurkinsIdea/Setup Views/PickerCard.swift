//
//  pickerCard.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: SwiftUI card that users select to choose which version of the app they want to use - the one for Restaurants or the one for non-Restaurants
*/
struct PickerCard: View {
    
    // Boolar variable that stores wheether the card should display itself as a the resturant card or the non-restaurant card
    var restaurant: Bool
    
    // State switch that tells the parent view that the card has been selected
    @Binding var selected: Bool
    
    // SwiftUI view constructor
    var body: some View {
        GeometryReader{
            geometry in
                if (self.restaurant){
                    if (self.selected){
                    HStack {
                        VStack(alignment: .leading) {
                            Text("I represent a")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                            Text("Restaurant")
                                .font(.title)
                                .fontWeight(.heavy)
                                .padding(.leading)
                                .foregroundColor(.primary)
                        }
                        
                        CardImage(image: Image("restaurantGeneric"))
                        .padding()
                    }
                    .frame(width: geometry.size.width - 20, height: 150) .background(Color.gray.opacity(0.1))
                    .border(Color.black, width: 2)
                    .cornerRadius(10)
                }
                else
                {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("I represent a")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                            Text("Restaurant")
                                .font(.title)
                                .fontWeight(.heavy)
                                .padding(.leading)
                                .foregroundColor(.primary)
                        }
                        
                        CardImage(image: Image("restaurantGeneric"))
                        .padding()
                    }
                   .frame(width: geometry.size.width - 20, height: 150) .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            else
            {
                if (self.selected){
                    HStack {
                        VStack(alignment: .leading) {
                            Text("I represent a")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                            Text("Shelter/\nFood Bank")
                                .font(.title)
                                .fontWeight(.heavy)
                                .padding(.leading)
                                .foregroundColor(.primary)
                        }
                        
                        CardImage(image: Image("shelterGeneric"))
                        .padding()
                    }
                   .frame(width: geometry.size.width - 20, height: 150) .background(Color.gray.opacity(0.1))
                    .border(Color.black, width: 2)
                    .cornerRadius(10)
                }
                else
                {
                    HStack {
                       VStack(alignment: .leading) {
                           Text("I represent a")
                               .font(.headline)
                               .fontWeight(.bold)
                               .foregroundColor(Color.gray)
                               .padding(.leading)
                           Text("Shelter/\nFood Bank")
                               .font(.title)
                               .fontWeight(.heavy)
                               .padding(.leading)
                               .foregroundColor(.primary)
                       }
                       
                       CardImage(image: Image("shelterGeneric"))
                       .padding()
                   }
                  .frame(width: geometry.size.width - 20, height: 150) .background(Color.gray.opacity(0.1))
                   .cornerRadius(10)
                }
            }
        }
    }
}

struct PickerCard_Previews: PreviewProvider {
    static var previews: some View {
        PickerCard(restaurant: false, selected: .constant(false))
    }
}
