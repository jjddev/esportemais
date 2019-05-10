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
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.vMapa.setRegion(region, animated: true)
        }
    }

}
