//
//  PropfileMap.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/22/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct ProfileMap: UIViewRepresentable {
    
    var coordinate: CLLocationCoordinate2D
    
    var pin: Bool

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: false)
        
        view.isZoomEnabled = false
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        
        if (pin)
        {
            let annotation = MKPointAnnotation();
            
            annotation.coordinate = self.coordinate
            
            view.addAnnotation(annotation)
        }
        
    }
}

struct ProfileMap_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMap(coordinate: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321), pin: false)
    }
}
