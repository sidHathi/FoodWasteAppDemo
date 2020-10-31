//
//  ProfileSummary.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/25/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct ProfileSummary: View {
    
    @EnvironmentObject var session: FirebaseSession
    @Binding var showingSheet: Bool
    @Binding var loggedOut: Bool
    
    var user: Profile
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading){
                Group{
                    VStack{
                        HStack{
                            Spacer()
                            CircleImage(image: user.image)
                            .padding(.bottom)
                            Spacer()
                        }
                        HStack{
                        Text(user.username)
                            .font(.title)
                            .fontWeight(.heavy)
                            Spacer()
                        }
                    }
                
                    Divider()
                }
                Group{
                
                    VStack(alignment: .leading){
                        Text("Notifications: ").font(.caption).fontWeight(.none)
                        .padding(.bottom, 5)
                        Text("\(self.user.prefersNotifications ? "On": "Off" )")
                    }
                    .padding(.leading, 8)
                
                    Divider()
                
                    VStack(alignment: .leading){
                        Text("Shelter Capacity: ").font(.caption).fontWeight(.none)
                        .padding(.bottom, 5)
                        Text("\(Int(self.user.people))")
                    }
                    .padding(.leading, 8)
                
                    Divider()
                    
                    VStack (alignment: .leading){
                        Text("Address: ").font(.caption).fontWeight(.none)
                            .padding(.bottom, 5)
                        Text("\(self.user.address)")
                    }
                    .padding(.leading, 8)
                    
                    Divider()
                }
                Group{
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            self.showingSheet.toggle()
                            self.loggedOut.toggle()
                            //self.session.logOut()
                        } )
                        {
                            HStack{
                                Spacer()
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 0.5, green: 0, blue: 0, opacity: 1))
                                Text("Log Out")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(Color(Color.RGBColorSpace.sRGB, red: 0.5, green: 0, blue: 0, opacity: 1))
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            .frame(width: 300)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        }
                        .padding()
                        Spacer()
                        
                    }
                
                }
                
                Spacer()
            }
        }
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
