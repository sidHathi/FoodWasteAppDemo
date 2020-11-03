//
//  CompleteList.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 8/12/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: This class constructs the the page within which users can find any restaurant pulled from Firebase
*/
struct CompleteList: View {
    
    // Array of restaurants pulled from firebase
    var restaurants: [Restaurant]
    
    // State variables that control which method should be used to sort the restaurants
    @State var none: Bool = true
    // Favorites functionality has not been implemented: placeholder for demo
    @State var favorites: Bool = false
    @State var proximity: Bool = false
    
    // SwiftUI view constructor
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
