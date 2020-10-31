//
//  RestaurantProfileBuilder.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct RestaurantProfileBuilder: View {
    
    @Binding var address: String
    @Binding var redAddress: Bool
    @Binding var city: String
    @Binding var redCity: Bool
    @Binding var state: String
    @Binding var redState: Bool
    @Binding var zip: String
    @Binding var redZip: Bool
    @Binding var name: String
    @Binding var redRName: Bool
    @Binding var description: String
    @Binding var redDescription: Bool
    @Binding var phone: String
    @Binding var redPhone: Bool
    @Binding var showingEmptyError: Bool
    @Binding var showingFormatError: Bool
    @Binding var showingAddressError: Bool

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
                Text("Phone numbers cannot contain letters")
                    .foregroundColor(.red)
            }
            else if (showingAddressError)
            {
                Text("Address incorectly formatted")
                    .foregroundColor(.red)
            }
            
            VStack(alignment:.leading){
                HStack{
                    Text("Enter Restaurant Name:")
                        .bold()
                        .font(.headline)
                    Spacer()
                    
                }
                .padding(.top)
                
                if (self.redRName){
                
                    TextField("Your Restaurant's Name", text: $name)
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
                    TextField("Your Restaurant's Name", text: $name)
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
                    Text("Enter Restaurant Description:")
                        .bold()
                        .font(.headline)
                    Spacer()
                    
                }
                .padding(.top)
                
                if (self.redRName){
                
                    TextField("A Short Description of your Restaurant", text: $description)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .frame(minWidth: 100, maxWidth: 200, minHeight: 20, maxHeight: .infinity, alignment: .topLeading)
                        
                        
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
                    TextField("A Short Description of your Restaurant", text: $description)
                        .frame(minWidth: 200, maxWidth: 400, minHeight: 40, maxHeight: .infinity, alignment: .topLeading)
                        .lineLimit(4).multilineTextAlignment(.leading)
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
                    Text("Enter Restaurant Address:")
                        .bold()
                        .font(.headline)
                    Spacer()
                    
                }
                .padding(.top)
                
                if (self.redAddress){
                
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
                
                if (self.redCity){
                
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
                
                if (self.redState){
                
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
                
                if (self.redZip){
                
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
            
            VStack(alignment:.leading){
                HStack{
                    Text("Contact Info")
                        .bold()
                        .font(.headline)
                    Spacer()
                    
                }
                .padding(.top)
                
                if (self.redRName){
                
                    TextField("Restaurant Phone Number", text: $phone)
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
                    TextField("Restaurant Phone Number", text: $phone)
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
            
            
           
        }
    }
}

struct RestaurantProfileBuilder_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantProfileBuilder(address: .constant(""), redAddress: .constant(false), city: .constant(""), redCity: .constant(false), state: .constant(""), redState: .constant(false), zip: .constant(""), redZip: .constant(false), name: .constant(""), redRName: .constant(false), description: .constant(""), redDescription: .constant(false), phone: .constant(""), redPhone: .constant(false), showingEmptyError: .constant(false), showingFormatError: .constant(false), showingAddressError: .constant(false))
    }
}
