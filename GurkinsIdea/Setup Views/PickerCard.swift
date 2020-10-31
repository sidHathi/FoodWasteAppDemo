//
//  pickerCard.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct PickerCard: View {
    var restaurant: Bool
    
    @Binding var selected: Bool
    
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
