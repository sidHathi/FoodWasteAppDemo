//
//  ProfileEditor.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/25/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: SwiftUI view class within which a non-restaurant user edits their profile info.
*/
struct ProfileEditor: View {
    
    // Current user's profile information
    @Binding var user: Profile
    
    // Boolean state switch that controls whether the popup within which a user can choose their profile image is shown
    @State private var showingImagePicker = false
    
    // User's image selection (default used for demo)
    @State private var inputImage = UIImage(named: "yosAvatar")
    
    // SwiftUI view constructor
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
            Group{
                
                HStack {
                    Text("Username").bold()
                    Divider()
                    TextField("Username", text: $user.username)
                }
                .frame(height: 30)
                .padding(.leading, 8)
                
                Divider()
                
                Toggle(isOn: $user.prefersNotifications) {
                    Text("Enable Notifications")
                }
                .frame(height: 30)
                .padding(.leading, 8)
                
                Divider()
                
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
                }
                .padding(.leading, 8)
                
                Divider()
                
                HStack {
                    Text("Address").bold()
                    Divider()
                    TextField("Address", text: $user.address)
                }
                .frame(height: 30)
                .padding(.leading, 8)
                
                Divider()
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
            
        }
    }
    
    // Function that sets the user's image to the one they selected
    func loadImage() {
        user.image = Image(uiImage: self.inputImage!)
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(user: .constant(Profile()))
    }
}
