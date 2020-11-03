//
//  TabView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: This Class serves as a replacement for the UITabBarView from UIKit built in SwiftUI.
 In the context of the program, it also passes the requisite UserData environment object to the
 views within it.
*/
struct TabBarView: View {
    
    // This variable contains a reference to the overarching UserData object for the entire app.
    @EnvironmentObject var userData: UserData
    
    // State: controls selected view
    @State var selectedView = 0
    
    // Determines which version of the app to display: The one oriented around restaurants, or
    // the one oriented around non-restaurants.
    var restaurant: Bool
    
    // SwiftUI View Constructor code
    var body: some View {
        TabView(selection: $userData.tab) {
            if (restaurant){
                RestaurantMain().environmentObject(userData)
                    .tabItem{
                        Image(systemName: "house")
                        Text("Home")
                }.tag(0)
                
                RestaurantSecondary().environmentObject(self.userData.session!)
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Scheduled")
                }.tag(1)
            }
            else
            {
                Main(map: true).environmentObject(self.userData)
                    .tabItem{
                        Image(systemName: "house")
                        Text("Home")
                }.tag(0)
                
                Secondary().environmentObject(self.userData)
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Scheduled")
                }.tag(1)
            }
        }
        //.accentColor(Color.black)
        //.edgesIgnoringSafeArea(.top)
        .font(.headline)
        .opacity(1)
    }
}

struct TabBarView_Previews: PreviewProvider {

    static var previews: some View {
        TabBarView(restaurant: false)
    }
}
