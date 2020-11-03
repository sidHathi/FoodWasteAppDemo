//
//  MainBrowseView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 8/12/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: This class displays the restaurants near the user in a visually compelling way that llows them to find the restaurants they're looking for quickly
*/
struct MainBrowseView: View {
    
    // All the restaurants pulled from Firebase
    var restaurants: [Restaurant]
    
    // SwiftUI view constructor
    var body: some View {
        
        VStack (alignment: .leading)
        {
            Group{
                Text("Near you:")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                if (restaurants.count > 0){
                    NavigationLink(destination: DetailView(restaurant: restaurants[0])){
                        
                        RestaurantCard(restaurant: restaurants[0])
                        .padding(.bottom, 8)
                    }
                }
                
                if (restaurants.count > 1){
                    NavigationLink(destination: DetailView(restaurant: restaurants[1])){
                        
                        RestaurantCard(restaurant: restaurants[1])
                        .padding(.bottom, 8)
                    }
                }
                
                NavigationLink(destination: CompleteList(restaurants: self.restaurants)){
                    
                    HStack
                    {
                        Spacer()
                        Text("See more >")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                }
            }
            
            /*
            Divider()
                .padding(.leading)
                .padding(.trailing)
                .padding(.top, 10)
                .padding(.bottom, 10)*/
            
            Text("Featured:")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: true)
            {
                HStack
                {
                    if (self.restaurants.count > 0){

                        VStack (alignment: .leading){
                            NavigationLink(destination: DetailView(restaurant: self.restaurants[0])){
                                
                                    FeaturedCard(restaurant: self.restaurants[0])
                                        .frame(width: UIScreen.main.bounds.width)
                                
                            }
                        }
                    }
                    
                    if (self.restaurants.count > 1){

                        VStack (alignment: .leading){
                            NavigationLink(destination: DetailView(restaurant: self.restaurants[1])){
                                
                                    FeaturedCard(restaurant: self.restaurants[1])
                                        .frame(width: UIScreen.main.bounds.width)
                                
                            }
                        }
                        
                        NavigationLink (destination: CompleteList(restaurants: restaurants)){
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .imageScale(.large)
                                .padding(30)
                                .background(Circle().fill(Color.black.opacity(0.05)))
                                .padding(.leading)
                                .padding(.trailing)
                        }
                    }
                    
                }
            }

            
            /*Divider()
                .padding(.leading)
                .padding(.trailing)
                .padding(.top, 10)
                .padding(.bottom, 10)*/
                
            Text("Browse:")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            HStack
            {
                Spacer()
                
                NavigationLink(destination: CompleteList(restaurants: restaurants)){
                    
                    VStack{
                        Image(systemName: "star.fill")
                            .imageScale(.large)
                            .padding(.top, 10)
                        Text("Favorites")
                            .font(.caption)
                            .padding(.top)
                    }
                    .frame(width: UIScreen.main.bounds.width*(3/8), height: 120)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.bottom)
                    .padding(.trailing)
                }
                     
                NavigationLink(destination: CompleteList(restaurants: restaurants)){
                    VStack{
                        Image(systemName: "arrow.right.circle.fill")
                            .imageScale(.large)
                            .padding(.top)
                        Text("See more")
                            .font(.caption)
                            .padding(.top, 10)
                    }
                    .frame(width: UIScreen.main.bounds.width*(3/8), height: 120)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.bottom)
                    .padding(.leading)
                }
                
                Spacer()
            }
        }
    
        
    }
}

struct MainBrowseView_Previews: PreviewProvider {
    static var previews: some View {
        MainBrowseView(restaurants: [Restaurant(), Restaurant(), Restaurant()])
    }
}

