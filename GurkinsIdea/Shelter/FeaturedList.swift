//
//  FeaturedList.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct FeaturedList: View {
    
    var listName: String
    var restaurants: [Restaurant]
    var withTitle: Bool
    
    var body: some View {
        VStack(alignment: .leading)
        {
            if (withTitle){
                Text(listName)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .padding(.leading, 10)
            }
            
            ScrollView(.horizontal, showsIndicators: false)
            {
                HStack (alignment: .top, spacing: 0)
                {
                    Text("")
                    
                    ForEach(restaurants, id: \.id)
                    {
                        restaurant in
                        NavigationLink(destination: DetailView(restaurant: restaurant))
                        {
                            ListItem(restaurant: restaurant)
                        }
                    }
                     
                }
            }
            .frame(height: 170)
        }
        .cornerRadius(10)
    }
}

struct ListItem: View
{
    var restaurant: Restaurant
    var body: some View
    {
        VStack(alignment: .leading) {
            Image("pagsLogo")
                .renderingMode(.original)
                .frame(width: 130, height: 130)
                .cornerRadius(5)
            Text(restaurant.name)
                .bold()
                .font(.subheadline)
                .foregroundColor(.primary)
            Text(restaurant.address)
                .font(.caption)
                .foregroundColor(.primary)
                .frame(width: 100, alignment: .leading)
                .lineLimit(1)
        }
        .padding(.leading, 15)
    }
}

struct FeaturedList_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedList(listName: "Near You", restaurants: [Restaurant(), Restaurant(), Restaurant()], withTitle: true)
    }
}
