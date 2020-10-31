//
//  RestaurantCard.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 8/11/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct RestaurantCard: View {
    
    var restaurant: Restaurant
    
    func getRelevantAddress(address: String) -> String
    {
        let parsedAddress = address.components(separatedBy: ", ")
        return parsedAddress[0]
    }
    
    var body: some View {
        
        HStack
        {
            Image("pagsLogo")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 85)
                .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .leading)
            {
                Text(restaurant.name)
                    .foregroundColor(.primary)
                    .font(.headline)
                    .bold()
                    .multilineTextAlignment(.leading)
                
                Text(getRelevantAddress(address: restaurant.address))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding(.top, 5)
                    .multilineTextAlignment(.leading)
                
            }
            .padding(.top, 5)
            .padding(.bottom, 5)
            .padding(.leading, 10)
            
            Spacer()
            
            VStack
            {
                Text("Verified")
                    .font(.caption)
                    .foregroundColor(Color.green.opacity(0.75))
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(Image.Scale.large)
                    .foregroundColor(Color.green.opacity(0.75))
            }
        .padding()
        }
        .background(Color.black.opacity(0.05))
        .cornerRadius(10)
        //.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
        //.shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        .padding(.trailing)
        .padding(.leading)
    }
}

struct RestaurantCard_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCard(restaurant: Restaurant())
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}
