//
//  CompleteList.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 8/12/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct CompleteList: View {
    var restaurants: [Restaurant]
    
    @State var none: Bool = true
    @State var favorites: Bool = false
    @State var proximity: Bool = false
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading){
                FilterView(none: self.$none, favorites: self.$favorites, proximity: self.$proximity)
                
                ForEach (restaurants, id: \.id)
                {
                    restaurant in
                    
                    NavigationLink(destination: DetailView(restaurant: restaurant)){
                        RestaurantCard(restaurant: restaurant)
                            .padding(.top)
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .navigationBarTitle("All Restaurants")
        
    }
}

struct CompleteList_Previews: PreviewProvider {
    static var previews: some View {
        CompleteList(restaurants: [Restaurant(), Restaurant(), Restaurant(), Restaurant(), Restaurant(), Restaurant(), Restaurant()])
    }
}
