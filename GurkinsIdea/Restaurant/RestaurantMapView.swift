//
//  RestaurantMapView.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 2/23/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

/**
Description:
 UNFINISHED
Type: UIView SwiftUI Representable Class
Functionality: Creates MapView that displays locaitons of users who are on their way to pickup food. Incomplete as of 11/01/2020
*/
struct RestaurantMapView: UIViewRepresentable {
    
    // Reference to pickups variable from parent view (RestaurantMain)
    @Binding var pickups: [Pickup]
     
    // Function that assigns class Coordinator
     func makeCoordinator() -> RestaurantMapView.Coordinator {
         Coordinator(self)
     }
     
    // location Manager
     let locationManager = CLLocationManager()
          
    // var coordinates: [CLLocationCoordinate2D]
          
    // Functon that returns an MKMapView and assigns delegate, coordinator
     func makeUIView(context: Context) -> MKMapView {
         let mapView = MKMapView()
         mapView.delegate = context.coordinator
         return mapView
     }

    // Function that adds locaitons to map
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
                let locValue = self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
                
                print("CURRENT LOCATION = \(locValue.latitude) \(locValue.longitude)")

                let coordinate = CLLocationCoordinate2D(
                 latitude: locValue.latitude-0.2, longitude: locValue.longitude)
             let span = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                view.setRegion(region, animated: true)
                
            
             /*
             for i in 0...(self.restaurants.count-1)
             {
                 let annotation = MKPointAnnotation();
                 
                 annotation.coordinate = self.restaurants[i].coordinates
                 
                 annotation.title = self.restaurants[i].name
                 
                 annotation.subtitle = self.restaurants[i].address
                 
                 view.addAnnotation(annotation)
             }
             */
                
                for i in 0...(self.pickups.count - 1)
                {
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = self.pickups[i].location
                        
                    annotation.subtitle = self.pickups[i].profile!.username
                    
                    let interval = self.pickups[i].time.timeIntervalSince(Date())
                    
                    var minutesSince = Int(round(interval/60))
                    
                    if minutesSince <= 0
                    {
                        minutesSince = 0
                    }
                    
                    annotation.title = String(minutesSince) + " min"
                    
                        view.addAnnotation(annotation)
                }
                 
            })
        }
     
         
    }
     
    // Coordinator class - used to edit annotations on pins, customize what appears for each locaiton
     class Coordinator: NSObject, MKMapViewDelegate
     {
         var parent: RestaurantMapView
         
         var annotationIndex = 0
         
         init(_ parent: RestaurantMapView)
         {
             self.parent = parent
         }
         /*
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
             
             for i in 0...(parent.restaurants.count-1)
             {
                 if (parent.restaurants[i].address == annotation.subtitle)
                 {
                     annotationView?.tag = i
                 }
             }
             
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
         */
     }
}

struct RestaurantMapView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMapView(pickups: .constant([Pickup(complete: true), Pickup(complete: true)]))
    }
}
