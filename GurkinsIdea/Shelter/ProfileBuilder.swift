//
//  ProfileBuilder.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/16/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import Firebase
import UIKit

struct ProfileBuilder: View {
    
    @Binding var page: Int
    @Binding var orgName: String
    @Binding var red1: Bool
    @Binding var address: String
    @Binding var red2: Bool
    @Binding var city: String
    @Binding var red3: Bool
    @Binding var state: String
    @Binding var red4: Bool
    @Binding var zip: String
    @Binding var red5: Bool
    @Binding var capacity: String
    @Binding var red6: Bool
    @Binding var showingEmptyError: Bool
    @Binding var showingFormatError: Bool
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    
    var body: some View {
        List{
            if (showingEmptyError)
           {
               Text("Complete required text fields")
                   .foregroundColor(.red)
           }
           else if (showingFormatError)
           {
               Text("Capacity must be a number greater than 0")
                   .foregroundColor(.red)
           }
            VStack(alignment:.leading){
                HStack{
                    Text("Enter Organization Name:")
                        .bold()
                        .font(.headline)
                    Spacer()
                    
                }
                .padding(.top)
                
                if (self.red1){
                
                    TextField("Your Organization's Name", text: $orgName)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.leading)
                        .background(lightGreyColor)
                        .border(Color.red)
                        .cornerRadius(5)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        
                }
                else
                {
                    TextField("Your Organization's Name", text: $orgName)
                       .padding(.top, 10)
                       .padding(.bottom, 10)
                       .padding(.leading)
                       .background(lightGreyColor)
                       .cornerRadius(5)
                       .padding(.leading)
                       .padding(.trailing)
                       .padding(.bottom)
                }
            }
            
            VStack(alignment:.leading){
                HStack{
                    Text("Enter Shelter/Food Bank Address:")
                        .bold()
                        .font(.headline)
                    Spacer()
                    
                }
                .padding(.top)
                
                if (self.red2){
                
                    TextField("Ex: 0000 0th St", text: $address)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.leading)
                        .background(lightGreyColor)
                        .border(Color.red)
                        .cornerRadius(5)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        
                }
                else
                {
                    TextField("Ex: 0000 0th St", text: $address)
                       .padding(.top, 10)
                       .padding(.bottom, 10)
                       .padding(.leading)
                       .background(lightGreyColor)
                       .cornerRadius(5)
                       .padding(.leading)
                       .padding(.trailing)
                       .padding(.bottom)
                }
                
                if (self.red3){
                
                    TextField("City", text: $city)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.leading)
                        .background(lightGreyColor)
                        .border(Color.red)
                        .cornerRadius(5)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        
                }
                else
                {
                    TextField("City", text: $city)
                       .padding(.top, 10)
                       .padding(.bottom, 10)
                       .padding(.leading)
                       .background(lightGreyColor)
                       .cornerRadius(5)
                       .padding(.leading)
                       .padding(.trailing)
                       .padding(.bottom)
                }
                
                if (self.red4){
                
                    TextField("State", text: $state)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.leading)
                        .background(lightGreyColor)
                        .border(Color.red)
                        .cornerRadius(5)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        
                }
                else
                {
                    TextField("State", text: $state)
                       .padding(.top, 10)
                       .padding(.bottom, 10)
                       .padding(.leading)
                       .background(lightGreyColor)
                       .cornerRadius(5)
                       .padding(.leading)
                       .padding(.trailing)
                       .padding(.bottom)
                }
                
                if (red5){
                
                    TextField("Zip", text: $zip)
                        .padding(.top, 10)
                       .keyboardType(.numberPad) .padding(.bottom, 10)
                        .padding(.leading)
                        .background(lightGreyColor)
                        .border(Color.red)
                        .cornerRadius(5)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        
                }
                else
                {
                    TextField("Zip", text: $zip)
                        .keyboardType(.numberPad)
                       .padding(.top, 10)
                       .padding(.bottom, 10)
                       .padding(.leading)
                       .background(lightGreyColor)
                       .cornerRadius(5)
                       .padding(.leading)
                       .padding(.trailing)
                       .padding(.bottom)
                }
                Spacer()
            }
            VStack(alignment: .leading)
            {
                Text("How many people does your shelter/food bank serve?")
                    .lineLimit(2)
                    .font(.headline)
                    .padding(.top)
                    
                if (self.red6){
                
                    TextField("Shelter Capacity", text: $capacity)
                        .keyboardType(.numberPad)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.leading)
                        .background(lightGreyColor)
                        .border(Color.red)
                        .cornerRadius(5)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        
                }
                else
                {
                    TextField("Shelter Capacity", text: $capacity)
                        .keyboardType(.numberPad)
                       .padding(.top, 10)
                       .padding(.bottom, 10)
                       .padding(.leading)
                       .background(lightGreyColor)
                       .cornerRadius(5)
                       .padding(.leading)
                       .padding(.trailing)
                       .padding(.bottom)
                }
            }
            .lineLimit(nil)
            
           
           
        }
               
    }
    
    func tryContinue()
    {
        if (self.orgName.isEmpty)
        {
            self.red1 = true
            self.showingEmptyError = true
        }
        else if (self.address.isEmpty)
        {
            self.red2 = true
            self.showingEmptyError = true
        }
        else if (self.state.isEmpty)
        {
            self.red3 = true
            self.showingEmptyError = true
        }
        else if (self.zip.isEmpty)
        {
            self.red4 = true
            self.showingEmptyError = true
        }
        else if (self.capacity.isEmpty)
        {
            self.red5 = true
            self.showingEmptyError = true
        }
        else
        {
            if (Int(self.capacity) == nil)
            {
                self.showingFormatError = true
            }
            else if (Int(self.capacity)! <= 0)
            {
                self.showingFormatError = true
            }
            else
            {
                self.page += 1
                self.showingEmptyError = false
                self.showingFormatError = false
            }
        }
    }
    
}

struct ProfileBuilder_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBuilder(page: .constant(1), orgName: .constant(""), red1: .constant(false), address: .constant(""), red2: .constant(false), city: .constant(""), red3: .constant(false), state: .constant(""), red4: .constant(false), zip: .constant(""), red5: .constant(false), capacity: .constant(""), red6: .constant(false), showingEmptyError: .constant(false), showingFormatError: .constant(false))
    }
}
