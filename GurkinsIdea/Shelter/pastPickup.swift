//
//  pastPickup.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/24/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import CoreLocation

struct pastPickup: View {
    var pickup: Pickup
    
    @State var restaurantLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    func getRestaurantLocation()
    {
        if (pickup.restaurantLocation != nil){
            restaurantLocation = pickup.restaurantLocation!
        }
        else
        {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(self.pickup.restaurantAddress)
            {
                (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                else {
                    // handle no location found
                    print("Invalid location.")
                    return
                }
                self.restaurantLocation = location.coordinate
            }
        }
    }
    
    var body: some View {
        VStack (alignment: .leading){
            ProfileMap(coordinate: self.restaurantLocation, pin: true)
                .frame(height: 100)
            Text("\(self.pickup.time, formatter: Self.dateFormatter)")
                .fontWeight(.bold)
                .font(.headline)
                .padding(.leading)
                .foregroundColor(.primary)
            HStack
            {
                Text(pickup.restaurantAddress)
                    .fontWeight(.bold)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(pickup.restaurantAddress)
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.primary)
            }
            .padding(.leading)
            .padding(.bottom)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
        .onAppear
        {
            self.getRestaurantLocation()
        }
    }
}

struct pastPickup_Previews: PreviewProvider {
    static var previews: some View {
        pastPickup(pickup: Pickup(complete: true))
    }
}
