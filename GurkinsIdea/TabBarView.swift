//
//  TabView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/21/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var userData: UserData
    
    @State var selectedView = 0
    
    var restaurant: Bool
    
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
