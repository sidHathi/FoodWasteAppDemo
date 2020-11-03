//
//  ControllerView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/15/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: This is the primary SwiftUI view class for the entire app. It coordinates the user's current firebase session status
 with the app's various SwiftUI view classes to ensure that the user is seeing the right information and all the SwiftUI
 classes have the information they need to display the right stuff to the user.
*/
struct ControllerView: View {
    
    // Overarching firebase session instance for connection to Firebase
    @ObservedObject var session = FirebaseSession()
    
    // Function that starts firebase session
    func getUser () {
        session.listen()
    }
    
    var body: some View {
        // Real-time updating group of SwiftUI views that uses Firebase session info to determine what views the user should be looking at.
        Group {
            if session.session != nil && session.isLoggedIn == true {
                if (session.userDataExists != nil){
                    if (session.userDataExists!)
                    {/*
                        VStack{
                            Text("We Have Data")
                            Button(action: {
                                self.session.logOut()
                            })
                            {
                                Text("Log Out")
                            }
                        }
                         
                         
                         */
                        if (session.profile != nil){
                            TabBarView(restaurant: false).environmentObject(UserData(profile: session.profile!, user: session.session!, session: session))
                        }
                        else if (session.restaurantProfile != nil)
                        {
                            TabBarView(restaurant: true).environmentObject(UserData(rProfile: session.restaurantProfile!, user: session.session!, session: session))
                        }
                        else
                        {
                            Button(action: {
                                self.session.logOut()
                            })
                            {
                                Text("Log Out")
                            }
                        }
                    }
                    else
                    {
                        SetupHost().environmentObject(session)
                    }
                }
                else
                {
                    VStack
                    {
                        ActivityIndicator()
                            .frame(width: 50, height: 50)
                    }
                }
                
           } else {
               LoginView()
           }
       }
       .onAppear(perform: getUser)
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
    }
}
