//
//  MapView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/20/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

/**
Description:
Type: UIView SwiftUI Representable Class
Functionality: This class constructs the UIMap that displays the location of nearby restaurants ot the user as a SwiftUI object. Includes constructor code for interactable map items that display text and buttons when expanded
*/
struct MapView: UIViewRepresentable {
    
    // Sets coordinator class
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    // Location manager
    let locationManager = CLLocationManager()
    
    // Array of restaurants that are displayed in the map
    var restaurants: [Restaurant]
    
   // var coordinates: [CLLocationCoordinate2D]
    
    // Reference to parent view (Main)
    var parent: Main
    
    // Function that builds an MKMapView with the appropriate coordinator and delegate
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    // Function that adds locations that need to be displayed on the map to the map
   func updateUIView(_ view: MKMapView, context: Context) {
       view.showsUserLocation = true

       // Ask for Authorisation from the User.
       self.locationManager.requestAlwaysAuthorization()

       // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
    
        let status = CLLocationManager.authorizationStatus()

       if status == .authorizedAlways || status == .authorizedWhenInUse {
           //        self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()

           //Temporary fix: App crashes as it may execute before getting users current location
           //Try to run on device without DispatchQueue

           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if (self.locationManager.location != nil){
                   let locValue:CLLocationCoordinate2D = self.locationManager.location!.coordinate
                   print("CURRENT LOCATION = \(locValue.latitude) \(locValue.longitude)")
                
                self.parent.userData.session?.profile?.setLocation(location: locValue)

                   let coordinate = CLLocationCoordinate2D(
                    latitude: locValue.latitude-0.15, longitude: locValue.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
                   let region = MKCoordinateRegion(center: coordinate, span: span)
                   view.setRegion(region, animated: true)
                
                if (self.restaurants.count > 0){
                    for i in 0...(self.restaurants.count-1)
                    {
                        let annotation = MKPointAnnotation();
                        
                        annotation.coordinate = self.restaurants[i].coordinates
                        
                        // Sets annotation title
                        annotation.title = self.restaurants[i].name
                        
                        // sets annotation subtext
                        annotation.subtitle = self.restaurants[i].address
                        
                        view.addAnnotation(annotation)
                    }
                }
            }
                
           })
       }
    
        
   }
    
    // Coordinator class that sets the items displayed on the map to show the right annotations and buttons.
    class Coordinator: NSObject, MKMapViewDelegate
    {
        var parent: MapView
        
        var annotationIndex = 0
        
        init(_ parent: MapView)
        {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
           if annotation is MKUserLocation {
                return nil
            }

            let identifier = "MyCustomAnnotation"

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }

            //configureDetailView(annotationView: annotationView!)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
               size: CGSize(width: 30, height: 30)))
            //mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
            mapsButton.setBackgroundImage(UIImage(systemName: "arrow.right.circle"), for: UIControl.State())
            
            // identifies the restaurants that each point on the map refers to and tags them appropriately
            if (parent.restaurants.count > 0){
                for i in 0...(parent.restaurants.count-1)
                {
                    if (parent.restaurants[i].address == annotation.subtitle)
                    {
                        annotationView?.tag = i
                    }
                }
            }
            
            // Adds the button to the annotations
            annotationView?.rightCalloutAccessoryView = mapsButton

            return annotationView
        }
        
        func configureDetailView(annotationView: MKAnnotationView) {
            let width = 100
            let height = 100

            let snapshotView = UIView()
            let views = ["snapshotView": snapshotView]
            snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(100)]", options: [], metrics: nil, views: views))
            snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(100)]", options: [], metrics: nil, views: views))
            

            let options = MKMapSnapshotter.Options()
            options.size = CGSize(width: width, height: height)
            options.mapType = .satelliteFlyover
            options.camera = MKMapCamera(lookingAtCenter: annotationView.annotation!.coordinate, fromDistance: 250, pitch: 65, heading: 0)

            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.start { snapshot, error in
                if snapshot != nil {
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                    imageView.layer.cornerRadius = CGFloat(width/2)
                    imageView.layer.masksToBounds = true
                    imageView.image = snapshot!.image
                    snapshotView.addSubview(imageView)
                }
            }

            annotationView.detailCalloutAccessoryView = snapshotView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            self.annotationIndex = 0
            self.parent.parent.selected = view.tag
            self.parent.parent.map = false
        }
        
    }
    
    // OBSOLETE
    class SampleAnnotation: NSObject, MKAnnotation
    {
        var coordinate: CLLocationCoordinate2D
        var phone: String!
        var name: String!
        var address: String!
        var image: UIImage!
        
        init(coordinate: CLLocationCoordinate2D) {
            self.coordinate = coordinate
        }
        
    }
    
    // class for Annotations that sets up selection/deselction
    class AnnotationView: MKAnnotationView
    {
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let hitView = super.hitTest(point, with: event)
            if (hitView != nil)
            {
                self.superview?.bringSubviewToFront(self)
            }
            return hitView
        }
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let rect = self.bounds
            var isInside: Bool = rect.contains(point)
            if(!isInside)
            {
                for view in self.subviews
                {
                    isInside = view.frame.contains(point)
                    if isInside
                    {
                        break
                    }
                }
            }
            return isInside
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(restaurants: [Restaurant(), Restaurant()], parent: Main(map: true))
    }
}
