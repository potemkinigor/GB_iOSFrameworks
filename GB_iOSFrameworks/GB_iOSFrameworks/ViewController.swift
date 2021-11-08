//
//  ViewController.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 02.11.2021.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var locationButton: UIButton! {
        didSet {
            locationButton.layer.zPosition = 1
        }
    }
    
    var mapView: GMSMapView!
    var locationManager: CLLocationManager?
    var updatingLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGoogleMaps()
        configureLocationManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deinitGoogleMaps()
    }
    
    @IBAction func didTapLocationButton(_ sender: Any) {
        if self.updatingLocation {
            self.locationManager?.stopUpdatingLocation()
            self.locationButton.setTitle("Start", for: .normal)
            
        } else {
            self.locationManager?.startUpdatingLocation()
            self.locationButton.setTitle("Stop", for: .normal)
        }
        
        self.updatingLocation.toggle()
    }
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 55.753215, longitude: 37.622504, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        self.view.bringSubviewToFront(self.locationButton)
    }
    
    func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func deinitGoogleMaps() {
        self.mapView.removeFromSuperview()
        self.mapView = nil
    }
    
    private func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        marker.icon = UIImage(systemName: "airtag")
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        let cameraPosition = GMSCameraPosition.camera(withTarget: coordinate, zoom: 13.0)
        self.mapView.animate(to: cameraPosition)
        self.addMarker(coordinate: coordinate)
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
     }

}
