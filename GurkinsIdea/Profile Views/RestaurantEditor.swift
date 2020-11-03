//
//  RestaurantEditor.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 8/7/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: SwiftUI view class within which  restaurant user's can edit their profile info.
*/
struct RestaurantEditor: View {
    
    // User's current data
    @Binding var user: RestaurantProfile
    
    // State switch that controls whether image picker is visible
    @State private var showingImagePicker = false
    
    // State variable that store profile image (set to default for demo
    @State private var inputImage = UIImage(named: "yosAvatar")
    
    // function that sets a user's profile image to the image they've selected
    func loadImage() {
        user.image = Image(uiImage: self.inputImage!)
    }
    
    // SwiftUI constructor view
    var body: some View {
        
        VStack (alignment: .leading) {
            HStack{
                Spacer()
                CircleImage(image: Image(uiImage: inputImage!))
                   .padding()
                    .onTapGesture {
                         self.showingImagePicker = true
                    }
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $user.name)
            }
            .frame(height: 30)
            .padding(.leading, 8)
            
            Divider()
            
            HStack {
                Text("Description").bold()
                Divider()
                TextField("Description", text: $user.description)
            }
            .frame(height: 30)
            .padding(.leading, 8)
            
            Divider()
            /*
            Toggle(isOn: $user.prefersNotifications) {
                Text("Enable Notifications")
            }
            */
            /*
            VStack(alignment: .leading) {
                HStack{
                    Text("Shelter Capacity").bold()
                    Text(String(Int(user.people)))
                }
                HStack {
                    Text("0")
                    Slider(value: $user.people, in: 0...200, step: 5)
                    Text("200+")
                }
            }*/
            
            HStack {
                Text("Address").bold()
                Divider()
                TextField("Address", text: $user.address)
            }
            .frame(height: 30)
            .padding(.leading, 8)
            Spacer()
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
            
        }
    }
}

struct RestaurantEditor_Previews: PreviewProvider {
    static var previews: some View {
        Text("View in Simulator")
    }
}
