//
//  Handle.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/22/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description: (CREDIT: https://gist.github.com/mshafer/7e05d0a120810a9eb49d3589ce1f6f40)
Type: SwiftUI Special View class
Functionality: Creates the handle for the swiftUI slide over card
*/
struct Handle : View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.gray)
            .padding(.top, 10)
    }
}

struct Handle_Previews: PreviewProvider {
    static var previews: some View {
        Handle()
    }
}
