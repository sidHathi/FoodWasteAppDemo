//
//  BrowseCard.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

struct BrowseCard: View {
    var restaurant: Restaurant
    
    var body: some View {
        NavigationLink(destination: DetailView(restaurant: self.restaurant)) {
            HStack {
                VStack(alignment: .leading) {
                    Text("FEATURED")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                        .padding(.leading)
                    Text(self.restaurant.name)
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.leading)
                        .foregroundColor(.primary)
                }
                Spacer()
                CardImage(image: Image("pagsLogo"))
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.leading)
            .padding(.trailing)
        }.edgesIgnoringSafeArea(.all)
    }
    
}

struct CardImage: View {
    var image: Image

    var body: some View {
        image
            .resizable(capInsets: EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
            .renderingMode(.original)
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .scaledToFit()
        
    }
}

struct BrowseCard_Previews: PreviewProvider {
    static var previews: some View {
        BrowseCard(restaurant: Restaurant())
    }
}
