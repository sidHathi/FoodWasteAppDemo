//
//  BrowseView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/22/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import UIKit

struct BrowseView: View {
    var restaurants: [Restaurant]
    var body: some View {
        VStack(alignment: .leading){
            VStack{
                FeaturedList(listName: "Near you", restaurants: self.restaurants, withTitle: true)
                Divider()
                BrowseCard(restaurant: self.restaurants[0])
                Divider()
                FeaturedList(listName: "Favorites", restaurants: self.restaurants, withTitle: true)
                Spacer().frame(height: 100)
            }
        }
        .padding(.top, 10)
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView(restaurants: [Restaurant(), Restaurant(), Restaurant()])
    }
}
