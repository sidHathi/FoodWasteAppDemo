//
//  SetupHost.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import CoreLocation
import Firebase

/**
Description:
Type: SwiftUI View Class
Functionality: Overarching SwiftUI view class within which a user sets up their profile for first-time use.
*/
struct SetupHost: View {
    
    // Overarching Firebase session var for app
    @EnvironmentObject var session: FirebaseSession
    
    // State switch that controls whether the user wants to be restaurant
    @State var restaurant: Bool = false
    // State switch that controls whether the user wants to be non-restaurant
    @State var shelter: Bool = false
    // State variable that controls which part of the setup process should be displayed
    @State var page: Int = 0
    // State variable that dictates whether an error message is shown
    @State var showingErrorMessage = false
    // State variable that contains info on whether the address is formatted correctly
    @State var addressFormatted: Bool? = nil
    
    // State switch that controls whether image picker view is displayed
    @State private var showingImagePicker = false
    // State variable that stores the image the user has chosen (set as default for demo)
    @State private var inputImage = UIImage(named: "yosAvatar")
    // State var that stores Firebase download path of user's profile image
    @State var imgDownloadURL: URL = URL(fileURLWithPath: "")
    
    // State variables that contain the information within the text-inputs in the setup subviews - the information that the user is entering for their profile - and the accompanying booleans for each of the entries that contain information on whether the info entered is invalid and an error message needs to be shown
    @State var orgName: String = ""
    @State var redOrgName = false
    @State var address: String = ""
    @State var redAddress = false
    @State var city: String = ""
    @State var redCity = false
    @State var state = ""
    @State var redState = false
    @State var zip: String = ""
    @State var redZip = false
    @State var capacity: String = ""
    @State var redCapacity = false
    @State var name: String = ""
    @State var redRName = false
    @State var description: String = ""
    @State var redDescription = false
    @State var phone: String = ""
    @State var redPhone = false
    
    // State variable that will contain user's location from address
    @State var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    // State switches that control which error message is displayed
    @State var showingEmptyError = false
    @State var showingFormatError = false
    @State var showingAddressError = false
    
    // Firebase storage references
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference()
    
    // Function that uploads a user's profile information to firebase
    func uploadProfile()
    {
        let image = self.inputImage!
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        let filePath = "\(Auth.auth().currentUser!.uid)/\("userPhoto")"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        self.storageRef.child(filePath).putData(data, metadata: metaData) { (metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
            //store downloadURL
                let size = metaData?.size
                                
                self.storageRef.child(filePath).downloadURL { (url, error) in
                    guard let downloadURL = url else
                    {
                        return
                    }
                    self.imgDownloadURL = downloadURL
                    let fullAddress = self.address + ", " + self.city + ", " + self.state + " USA " + self.zip
                    
                    
                    if (self.shelter){
                        let profile = Profile(username: self.orgName, prefersNotifications: true, favorites: [], scheduled: [], history: [], address: fullAddress, people: Double(Int(self.capacity)!), image: self.inputImage!)
                        
                        let docData: [String: Any] = [
                            "name": self.orgName,
                            "address": fullAddress,
                            "capacity": Int(self.capacity)!,
                            "notifications": true,
                            "scheduled": [],
                            "favorites": [],
                            "history": [],
                            "imageURL": self.imgDownloadURL.absoluteString,
                            "restaurant": false
                        ]
                        self.session.db.collection("users").document(self.session.session!.uid).setData(docData) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        self.session.profile = profile
                        self.session.userDataExists = true
                    }
                    else
                    {
                        let restaurantProfile = RestaurantProfile(name: self.name, address: self.address, description: self.description, phone: self.phone, location: self.location, availability: false, aFood: [], rFood: [], cPickups: [], history: [])
                        let docData: [String: Any] = [
                            "name": self.name,
                            "description": self.description,
                            "address": fullAddress,
                            "phone": self.phone,
                            "latitude": Double(self.location.latitude),
                            "longitude": Double(self.location.longitude),
                            "notifications": true,
                            "availableFood": [],
                            "reservedFood": [],
                            "current": [],
                            "history": [],
                            "imageURL": self.imgDownloadURL.absoluteString,
                            "restaurant": true
                        ]
                        self.session.db.collection("users").document(self.session.session!.uid).setData(docData) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                                print(self.session.session!.uid)
                                
                                self.session.db.collection("restaurants").document("index").updateData(["restaurants": FieldValue.arrayUnion([self.session.session!.uid])])
                                 { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                            }
                        }
                        
                        self.session.restaurantProfile = restaurantProfile
                        self.session.userDataExists = true
                    }
                }
            }
        }
    }
    
    // SwiftUI stylized Button that takes user back in the setup process
    var logOutButton: some View
    {
        Button(action:{
            if (self.page == 0){
                self.session.logOut()
            }
            else
            {
                self.page -= 1
            }
        })
        {
            HStack{
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
    
    // SwiftUI profile building object
    var profileBuilder: ProfileBuilder
    {
        ProfileBuilder(page: self.$page, orgName: self.$orgName, red1: self.$redOrgName, address: self.$address, red2: self.$redAddress, city: self.$city, red3: self.$redCity, state: self.$state, red4: self.$redState, zip: self.$zip, red5: self.$redZip, capacity: self.$capacity, red6: self.$redCapacity, showingEmptyError: self.$showingEmptyError, showingFormatError: self.$showingFormatError)
    }
    
    // Function that tests the user's inputs during a certain part of the setup. If the inputs are valid, it advances the user in the setup process. If not, it displays appropriate error messages
    func tryContinue()
    {
        if (shelter){
            if (self.orgName.isEmpty)
            {
                self.redOrgName = true
                self.showingEmptyError = true
            }
            else if (self.address.isEmpty)
            {
                self.redAddress = true
                self.showingEmptyError = true
            }
            else if (self.state.isEmpty)
            {
                self.redState = true
                self.showingEmptyError = true
            }
            else if (self.zip.isEmpty)
            {
                self.redZip = true
                self.showingEmptyError = true
            }
            else if (self.capacity.isEmpty)
            {
                self.redCapacity = true
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
        else
        {
            if (self.name.isEmpty)
            {
                self.redRName = true
                self.showingEmptyError = true
            }
            else if (self.description.isEmpty)
            {
                self.redDescription = true
                self.showingEmptyError = true
            }
            else if (self.address.isEmpty)
            {
                self.redAddress = true
                self.showingEmptyError = true
            }
            else if (self.state.isEmpty)
            {
                self.redState = true
                self.showingEmptyError = true
            }
            else if (self.zip.isEmpty)
            {
                self.redZip = true
                self.showingEmptyError = true
            }
            else if (self.phone.isEmpty)
            {
                self.redPhone = true
                self.showingEmptyError = true
            }
            else
            {
                let letters = CharacterSet.letters
                let letterRange = self.phone.rangeOfCharacter(from: letters)
                
                let fullAddress = self.address + ", " + self.city + ", " + self.state + " USA " + self.zip
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(fullAddress)
                {
                    (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                    else {
                        // handle no location found
                        self.showingAddressError = true
                        return
                    }
                    self.location = location.coordinate

                    if (self.location.latitude != CLLocationCoordinate2D().latitude || self.location.longitude != CLLocationCoordinate2D().longitude)
                    {
                        self.addressFormatted = true
                    }
                    else
                    {
                        self.addressFormatted = false
                    }
                    if (self.addressFormatted != nil){
                        if (letterRange != nil)
                        {
                            self.showingFormatError = true
                        }
                        else if (!(self.addressFormatted!))
                        {
                            self.showingAddressError = true
                        }
                        else
                        {
                            self.page += 1
                            self.showingEmptyError = false
                            self.showingFormatError = false
                            self.showingAddressError = false
                        }
                    }
                }
                
            }
        }
    }
    
    // SwiftUI View constructor
    var body: some View {
        
        GeometryReader{
            geometry in
            NavigationView{
                VStack(alignment: .center){
                    if (self.page == 0){
                        HStack{
                            Text("Which applies to you?")
                                .font(.headline)
                                .bold()
                                .padding()
                            Spacer()
                        }
                        Button(action:{
                            self.restaurant = true
                            self.shelter = false
                        })
                        {
                            PickerCard(restaurant: true, selected: self.$restaurant)
                                .frame(width: geometry.size.width, height: 150)
                        }
                        .padding(.leading)
                        
                        Divider().padding()
                                            
                        Button(action:{
                            self.shelter = true
                            self.restaurant = false
                        })
                        {
                            PickerCard(restaurant: false, selected: self.$shelter)
                            .frame(width: geometry.size.width, height: 150)
                        }
                        .padding(.leading)
                        
                    }
                    else if (self.page == 1)
                    {
                        if (self.shelter)
                        {
                            ProfileBuilder(page: self.$page, orgName: self.$orgName, red1: self.$redOrgName, address: self.$address, red2: self.$redAddress, city: self.$city, red3: self.$redCity, state: self.$state, red4: self.$redState, zip: self.$zip, red5: self.$redZip, capacity: self.$capacity, red6: self.$redCapacity, showingEmptyError: self.$showingEmptyError, showingFormatError: self.$showingFormatError)
                        }
                        else if (self.restaurant)
                        {
                            RestaurantProfileBuilder(address: self.$address, redAddress: self.$redAddress, city: self.$city, redCity: self.$redCity, state: self.$state, redState: self.$redState, zip: self.$zip, redZip: self.$redZip, name: self.$name, redRName: self.$redRName, description: self.$description, redDescription: self.$redDescription, phone: self.$phone, redPhone: self.$redPhone, showingEmptyError: self.$showingEmptyError, showingFormatError: self.$showingFormatError, showingAddressError: self.$showingAddressError)
                        }
                    }
                    else if (self.page == 2)
                    {
                        Spacer()
                        VStack(alignment:.center){
                            Text("Select Profile Image (Optional)")
                                .font(.headline)
                                .fontWeight(.bold)
                            CircleImage(image: Image(uiImage: self.inputImage!))
                            .padding()
                             .onTapGesture {
                                  self.showingImagePicker = true
                             }
                            Text("Click continue to skip.")
                        }
                        Spacer()
                    }
                        
                    Spacer()
                    
                    HStack{
                        Spacer()
                        VStack{
                            if (self.showingErrorMessage)
                            {
                                Text("Complete required fields")
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                            }
                            Button(action:{
                                if (!self.restaurant && !self.shelter)
                                {
                                    self.showingErrorMessage = true
                                }
                                else
                                {
                                    self.showingErrorMessage = false
                                    if (self.page == 0)
                                    {
                                        self.page += 1
                                    }
                                    else if (self.page == 1)
                                    {
                                        self.tryContinue()
                                    }
                                    else
                                    {
                                        self.uploadProfile()
                                    }
                                }
                            }){
                                Text("Continue")
                                    .font(.headline)
                                    .bold()
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .padding(.leading, 100)
                                    .padding(.trailing, 100)
                                    .background(Color.black)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                                .padding()
                            }
                        }
                        Spacer()
                    }
                    .sheet(isPresented: self.$showingImagePicker) {
                        ImagePicker(image: self.$inputImage)
                        
                    }
                }
                .navigationBarTitle("Account Setup")
                .navigationBarItems(leading: self.logOutButton)
            }
        }
        
    }
}

struct SetupHost_Previews: PreviewProvider {
    static var previews: some View {
        SetupHost().environmentObject(FirebaseSession())
    }
}
