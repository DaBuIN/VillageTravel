//
//  MapNavVC.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 13/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapNavVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locMgr:CLLocationManager!
    
    var locCurrent:CLLocationCoordinate2D?
    var locDest:CLLocationCoordinate2D?
    var nameDest:String?

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    
    public func addPointAnnotation( point: CLLocationCoordinate2D ) {
        
        // create pin
        let pin:MKPointAnnotation = MKPointAnnotation()
        
        pin.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        pin.title = nameDest!
        pin.subtitle = "lat:\(pin.coordinate.latitude), lng:\(pin.coordinate.longitude)"
        
        // show pin
        //        print(pin.title!)
        //        print(pin.description)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion(center: pin.coordinate, span: span)
        
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(pin)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5) )
        
//        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
//        self.mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            locMgr = CLLocationManager()
            locMgr.delegate = self
            locMgr.desiredAccuracy = kCLLocationAccuracyBest
            locMgr.requestWhenInUseAuthorization()
            
            locMgr.startUpdatingLocation()
            locMgr.distanceFilter = CLLocationDistance(10)
            
            print("map ready")
        }

        navBar.topItem?.title = nameDest ?? "Destination"
        mapView.delegate = self
        self.addPointAnnotation(point: locDest! )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locMgr.startUpdatingLocation()
    }
 
    

   

}
