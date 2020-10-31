//
//  Handle.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/22/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

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
