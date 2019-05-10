//
//  LocalViewController.swift
//  esportemais
//
//  Created by PUCPR on 10/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocalViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var vMapa: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        vMapa.mapType = .standard
        vMapa.isZoomEnabled = true
        vMapa.isScrollEnabled = true

        if let coor = vMapa.userLocation.location?.coordinate{
            vMapa.setCenter(coor, animated: true)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            
            let logitude = -49.251087
            let latitude = -25.451739
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.vMapa.setRegion(region, animated: true)
        }
    }

}
