//
//  ActivityIndicator.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/20/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import Foundation
import SwiftUI

/**
Description:
Type: SwiftUI View Class
Functionality: Builds the animating loading indicator used in various parts of the app
*/
struct ActivityIndicator: View {

    // State switch that stores whether the indicator is should be animating
  @State private var isAnimating: Bool = false

    // SwiftUI view constructor
  var body: some View {

    GeometryReader { (geometry: GeometryProxy) in

      ForEach(0..<5) { index in

        Group {

          Circle()

            .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)

            .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)

            .offset(y: geometry.size.width / 10 - geometry.size.height / 2)

          }.frame(width: geometry.size.width, height: geometry.size.height)

            .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))

            .animation(Animation

              .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)

              .repeatForever(autoreverses: false))

        }

      }.aspectRatio(1, contentMode: .fit)

        .onAppear {

          self.isAnimating = true

        }

  }

}
