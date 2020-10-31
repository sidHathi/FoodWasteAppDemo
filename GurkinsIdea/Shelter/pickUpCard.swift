//
//  pickUpCard.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct pickUpCard: View {
    
    var parent : Secondary
    
    var pickup: Pickup
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {

        VStack(alignment: .leading) {
            if (!pickup.canceled){
                HStack {
                    CardImage(image: Image("pagsLogo"))
                        .padding()
                    
                    ProfileMap(coordinate: pickup.restaurant!.coordinates, pin: true)
                        .frame(height: 150)
                        .cornerRadius(10)
                }
                HStack()
                {
                    Text(pickup.restaurantName)
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.leading, 10)
                    Spacer()
                    
                    Image(systemName: "phone.circle")
                        .padding()
                    Image(systemName: "car.fill")
                        .padding()
                }
                
                
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                
                Text("Pickup Time: ")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .foregroundColor(Color.gray)
                
                Text("\(self.pickup.time, formatter: Self.dateFormatter)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading)
                
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                
                HStack {
                    Spacer()
                    VStack(alignment: .center){
                        Button(action:{
                            self.parent.removePickup(pickup: self.pickup, cancelation: false)
                        })
                        {
                            Text("Confirm")
                                .font(.subheadline)
                                .bold()
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 100)
                                .padding(.trailing, 100)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .background(Color.primary)
                                .cornerRadius(10)
                                .padding(.top, 10)
                        }
                        Button(action:{
                            self.parent.removePickup(pickup: self.pickup, cancelation: true)
                        })
                        {
                            Text("Cancel")
                                .font(.subheadline)
                                .bold()
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 100)
                                .padding(.trailing, 100)
                                .foregroundColor(Color.primary)
                                .background(Color.primary.opacity(0.05))
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
            else
            {
                HStack {
                    CardImage(image: Image("pagsLogo"))
                        .padding()
                    
                    ProfileMap(coordinate: pickup.restaurant!.coordinates, pin: true)
                        .frame(height: 150)
                        .cornerRadius(10)
                }
                .opacity(0.25)
                HStack()
                {
                    Text(pickup.restaurantName)
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.leading, 10)
                    Spacer()
                    
                    Image(systemName: "phone.circle")
                        .padding()
                    Image(systemName: "car.fill")
                        .padding()
                }
                .opacity(0.25)
                
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                    .opacity(0.25)
                
                Text("Pickup Time: ")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .foregroundColor(Color.gray)
                    .opacity(0.25)
                
                Text("\(self.pickup.time, formatter: Self.dateFormatter)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading)
                    .opacity(0.25)
                
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                    .opacity(0.25)
                
                HStack {
                    Spacer()
                    VStack{
                        Text(self.pickup.cancelationMessage!)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.red)
                            .font(.subheadline)
                            .padding()
                    }
                    Spacer()
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

struct pickUpCard_Previews: PreviewProvider {
    static var previews: some View {
        pickUpCard(parent: Secondary(), pickup: Pickup(complete: true))
    }
}
