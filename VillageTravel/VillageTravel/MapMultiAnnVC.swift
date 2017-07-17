//
//  MapMultiAnnVC.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 17/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapMultiAnnVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pins:Array<MKPointAnnotation>?
    var locations:Array<CLLocationCoordinate2D>?
    var titleAnns:Array<String>?
//    var annsCont:Array<[String:AnyObject]>?
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.setAnnsToMap()

        print("viewDidLoad")

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.setAnnsToMap()
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.pins!)
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.global().async {
            for i in 0..<self.pins!.count {
                print("\(i): \(self.pins![i].title!)")
            }
        }
        

    }
    
    private func setAnnsToMap() {
        if let count:Int = locations!.count {
            
            if count != titleAnns!.count {
                return
            } else {
                
                self.pins = []
                
                for i in 0..<count {
                    let pin:MKPointAnnotation = MKPointAnnotation()
                    
                    DispatchQueue.global().async {
                        
                        pin.coordinate = self.locations![i]
                        pin.title = self.titleAnns![i]
                        pin.subtitle = "lat:\(pin.coordinate.latitude), lng:\(pin.coordinate.longitude)"
//                        print("\(i): async, \(pin.title!)")
                        
                    }
                    
                    DispatchQueue.global().sync {

                        self.pins! += [pin]

                    }
                }
                
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
