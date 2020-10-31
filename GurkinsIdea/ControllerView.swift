//
//  ControllerView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/15/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct ControllerView: View {
    
    @ObservedObject var session = FirebaseSession()
    
    func getUser () {
        session.listen()
    }
    
    var body: some View {
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
