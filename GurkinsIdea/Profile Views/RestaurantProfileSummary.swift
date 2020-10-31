//
//  RestaurantProfileSummary.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 8/7/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct RestaurantProfileSummary: View {
    
    @EnvironmentObject var session: FirebaseSession
    @Binding var showingSheet: Bool
    @Binding var loggedOut: Bool
    
    var user: RestaurantProfile

    var body: some View {
        
        VStack (alignment: .leading) {
            Group{
                VStack{
                    HStack{
                        Spacer()
                        CircleImage(image: user.image)
                        .padding(.bottom)
                        Spacer()
                    }
                    HStack{
                        Text(user.name)
                            .font(.title)
                            .fontWeight(.heavy)
                        Spacer()
                    }
                }
                Divider()
            }
                //Text("Notifications: \(self.user.prefersNotifications ? "On": "Off" )")
                //Divider()
                //Text("Shelter Capacity: \(Int(self.user.people))")
                //Divider()
            Group{
                VStack (alignment: .leading){
                    Text("Description: ").font(.caption).fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("\(self.user.description)")
                }
                .padding(.leading, 8)
                .listRowInsets(EdgeInsets())
                
                Divider()
                
                VStack (alignment: .leading){
                    Text("Address: ").font(.caption).fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("\(self.user.address)")
                }
                .padding(.leading, 8)
                .listRowInsets(EdgeInsets())
                
                Divider()
                
                //FeaturedList(listName: "Favorites", restaurants: self.user.favorites, withTitle: true)
                //Divider()
            }
            
            Group{
                HStack{
                    Spacer()
                    Button(action: {
                        self.showingSheet.toggle()
                        self.loggedOut.toggle()
                        //self.session.logOut()
                    } )
                    {
                        HStack{
                            Spacer()
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 0.5, green: 0, blue: 0, opacity: 1))
                            Text("Log Out")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 0.5, green: 0, blue: 0, opacity: 1))
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                        .frame(width: 300)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                }
                
                
            }
            
            Spacer()
        }
    }
}

struct RestaurantProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        Text("Run this on simulator to see it")
    }
}
