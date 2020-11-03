//
//  FilterView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 8/12/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: This class constructs the menu used within the CompleteList view to choose the sorting method for restaurants
*/
struct FilterView: View {
    
    // State variable that toggles when the view is tapped and controls whether it appears expanded or compact
    @State var tapped = false
    
    // References to State variables in CompleteList
    @Binding var none: Bool
    @Binding var favorites: Bool
    @Binding var proximity: Bool
    
    // SwiftUI view constructor
    var body: some View {
        VStack (alignment: .leading)
        {
            HStack
            {
                Spacer()
                if (self.none){
                    Text("None")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                }
                else if (self.favorites)
                {
                    Text("Favorites only")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                }
                else
                {
                    Text("By proximity")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                    
                }
                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                    .foregroundColor(.blue)
            }
            .padding(.trailing)
            .onTapGesture {
                self.tapped.toggle()
            }
            if (tapped)
            {
                VStack
                {
                    HStack{
                        Button(action: {
                            self.none = true
                            self.favorites = false
                            self.proximity = false
                        })
                        {
                            if (self.none){
                                Text("None")
                                    .font(.subheadline)
                                    .bold()
                            }
                            else
                            {
                                Text("None")
                                    .font(.subheadline)
                                    .opacity(0.5)
                            }
                        }
                        Spacer()
                        if (self.none){
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .hidden()
                        }
                    }
                    Divider()
                    HStack{
                        Button(action: {
                            self.none = false
                            self.favorites = true
                            self.proximity = false
                        })
                        {
                            if (self.favorites){
                                Text("Favorites only")
                                    .font(.subheadline)
                                    .bold()
                            }
                            else
                            {
                                Text("Favorites only")
                                    .font(.subheadline)
                                    .opacity(0.5)
                            }
                        }
                        Spacer()
                        if (self.favorites){
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .hidden()
                        }
                    }
                    Divider()
                    HStack{
                        Button(action: {
                            self.none = false
                            self.favorites = false
                            self.proximity = true
                        })
                        {
                            if (self.proximity){
                                Text("By proximity")
                                    .font(.subheadline)
                                    .bold()
                            }
                            else
                            {
                                Text("By proximity")
                                    .font(.subheadline)
                                    .opacity(0.5)
                            }
                        }
                        Spacer()
                        if (self.proximity){
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                            .hidden()
                        }
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 8)
                
                HStack{
                    Spacer()
                    Button(action:{self.tapped.toggle()}){
                        Image(systemName: "chevron.compact.up")
                            .imageScale(.large)
                    }
                    Spacer()
                }
            }
            Divider().edgesIgnoringSafeArea(.all)
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(none: .constant(true), favorites: .constant(false), proximity: .constant(false))
    }
}
