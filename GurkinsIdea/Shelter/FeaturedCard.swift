//
//  FeaturedCard.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 8/11/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct FeaturedCard: View {
    
    var restaurant: Restaurant
    
    func getRelevantAddress(address: String) -> String
    {
        let parsedAddress = address.components(separatedBy: ", ")
        return parsedAddress[0]
    }
    
    var body: some View {
        VStack (alignment: .leading)
        {
            Spacer()
            HStack
            {
                VStack (alignment: .leading){
                    Text(getRelevantAddress(address: restaurant.address))
                        .font(.caption)
                        .foregroundColor(.white)
                    Text(restaurant.name)
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .padding()
        .frame(height: 120)
        .background(
            Image("restaurantStock")
                .renderingMode(.original)
                .brightness(-0.5)
                .blur(radius: 2)
        )
        .cornerRadius(10)
        //.shadow(color: Color.black.opacity(0.05), radius: 10, x: 5, y: 5).shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
       // .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
    }
}

struct FeaturedCard_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedCard(restaurant: Restaurant())
    }
}
