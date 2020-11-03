//
//  UpcomingList.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import CoreLocation

/**
Description:
Type: SwiftUI View Class
Functionality: This class creates a SwiftUI view representation of an upcoming pickup that's displayed to a restaurant in the Restaurant's main view.
*/
struct UpcomingList: View {
    
    // Reference to RestaurantMain view within this view appears
    var parent: RestaurantMain
    // Pickup being represented/displayed in this view
    var pickup: Pickup
    // Boolean State var that controls whether the card is expanded or not
    @State var tapped: Bool = false
    
    // Date Formatter
    var formatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }
    
    // Function that converts the full address string into a shortened one
    func getRelevantAddress(address: String) -> String
    {
        let parsedAddress = address.components(separatedBy: ", ")
        return parsedAddress[0]
    }
    
    // Function that computes minutes left until pickup time
    func getMinutesUntilPickup() -> Int
    {
        return pickup.time.minutes(from: Date())
    }
    
    // Function that computes hours left until pickup time
    func getHoursUntilPickup() -> Int
    {
        return pickup.time.hours(from: Date())
    }
    
    // Function that returns the the string representation of time left until pickup
    func getPickupIntervalString() -> String
    {
        if (getMinutesUntilPickup() > 90)
        {
            if (getHoursUntilPickup() < 2){
                return String(getHoursUntilPickup()) + " hr"
            }
            else
            {
                return String(getHoursUntilPickup()) + " hrs"
            }
        }
        else
        {
            if (getMinutesUntilPickup() < 0)
            {
                return "EXP"
            }
            else
            {
                return String(getMinutesUntilPickup()) + " min"
            }
        }
    }
    
    // Function that sets background color of tableViews
    func setUI()
    {
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    // SwiftUI view Constructor
    var body: some View {
        VStack
        {
            
            HStack
            {
                
                MiniCircle(image: Image("shelterGeneric"))
                    .padding(.leading)
                    .padding(.trailing)
                
                VStack (alignment: .leading)
                {
                    Text(pickup.shelterName)
                        .foregroundColor(.primary)
                        .font(.headline)
                        .bold()
                        .multilineTextAlignment(.leading)
                    
                    Text(getRelevantAddress(address: pickup.shelterAddress))
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .padding(.top, 5)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                VStack (alignment: .trailing){
                    Text("Pickup In:")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                        .padding(.top, 4)
                    Text(getPickupIntervalString())
                        .bold()
                        .foregroundColor(.primary)
                        .font(.title)
                        .multilineTextAlignment(.trailing)
                    Spacer()
                }
            }
            .onTapGesture {
                self.tapped.toggle()
            }
            .frame(height: 40)
            if (tapped)
            {
                HStack
                {
                    ProfileMap(coordinate: pickup.location, pin: true)
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                    VStack (alignment: .leading)
                    {
                        Text("Pickup Time:")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Text(formatter.string(from: pickup.time))
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.bottom)
                        
                        Text("Order Details:")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            
                        List
                        {
                            ForEach(self.pickup.food, id: \.id)
                            {
                                food in
                                HStack
                                {
                                    Text(food.name)
                                        .font(.caption)
                                    Spacer()
                                    Text(String(food.selectedQuantity)).bold()
                                }
                                .listRowBackground(Color.black.opacity(0.05))
                            }
                            .listRowBackground(Color.black.opacity(0.05))
                        }
                        Spacer()
                        
                    }
                    .frame(height: 150)
                    .padding(.leading, 8)
                    Spacer()
                }
                .padding(.top)
                
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
                    .padding(.top)
                    .onTapGesture {
                        self.tapped.toggle()
                        self.parent.removePickup(pickup: self.pickup, cancel: false)
                    }
                
                
                Text("Cancel")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .bold()
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 100)
                    .padding(.trailing, 100)
                    .foregroundColor(Color.primary)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.top)
                    .onTapGesture {
                        self.tapped.toggle()
                        self.parent.removePickup(pickup: self.pickup, cancel: true)
                    }
            }
            
        }
        .padding(.top, 5)
        .padding(.bottom, 5)
        .padding()
        .background(Color.primary.opacity(0.05))
        .cornerRadius(10)
        .padding(.trailing)
        .padding(.leading)
        .onAppear
        {
            self.setUI()
        }
    }
}

/**
 Description:
 Type: SwiftUI View Class
 Functionality: This class creates the neumorphic profile image used in the card
 */
struct MiniCircle: View
{
    // Profile image
    var image: Image
    
    // SwiftUI view constructor
    var body: some View
    {
        image
            .renderingMode(.original)
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .scaledToFit()
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: -10, y: 10)
    }
}

struct UpcomingList_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingList(parent: RestaurantMain(), pickup: Pickup(complete: false))
    }
}

// Extension to Date that allows for easy computations of differences in Dates.
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
