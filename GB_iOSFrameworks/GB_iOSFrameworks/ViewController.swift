//
//  ViewController.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 02.11.2021.
//

import UIKit
import GoogleMaps
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var restoreLastRootButton: UIButton!
    @IBOutlet weak var startTrackButton: UIButton!
    @IBOutlet weak var stopTrackButton: UIButton!
    
    var mapView: GMSMapView!
    var locationManager: CLLocationManager?
    
    var beginBackgroundTask: UIBackgroundTaskIdentifier?
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    var rootCoordinates: List<LastRootPoint> = List<LastRootPoint>()
    
    var isUpdatingLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGoogleMaps()
        configureLocationManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deinitGoogleMaps()
    }
    
    @IBAction func didTapRestoreLastRootButton(_ sender: Any) {
        let realm = try! Realm()
        guard let lastRoot = realm.objects(LastRoot.self).last else { return }
        
        cleanRoot()
        
        for coordinate in lastRoot.rootCoordinates {
            let coordinate = CLLocationCoordinate2D(latitude: coordinate.lat!, longitude: coordinate.long!)
            routePath?.add(coordinate)
        }
        
        route?.path = routePath
        
        guard let lastCoordinate = lastRoot.rootCoordinates.last else { return }
        let target = CLLocationCoordinate2D(latitude: lastCoordinate.lat!, longitude: lastCoordinate.long!)
        let position = GMSCameraPosition.camera(withTarget: target, zoom: 17)
        mapView.animate(to: position)
    }
    
    @IBAction func didTapStartTrackButton(_ sender: Any) {
        if !isUpdatingLocation {
            cleanRoot()
            self.locationManager?.startUpdatingLocation()
            self.isUpdatingLocation = true
        } else {
            self.showAlert(title: "Ошибка", message: "Обновление локации уже в процессе")
        }
    }
    
    @IBAction func didTapStopTrackLocationButton(_ sender: Any) {
        if isUpdatingLocation {
            self.locationManager?.stopUpdatingLocation()
            let realm = try! Realm()
            try! realm.write {
                let root = LastRoot()
                root.rootCoordinates = self.rootCoordinates
                realm.add(root)
            }
        } else {
            self.showAlert(title: "Ошибка", message: "Обновление локации не запущено")
        }
    }
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 55.753215, longitude: 37.622504, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        self.view.bringSubviewToFront(self.restoreLastRootButton)
        self.view.bringSubviewToFront(self.startTrackButton)
        self.view.bringSubviewToFront(self.stopTrackButton)
    }
    
    func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.pausesLocationUpdatesAutomatically = false
        self.locationManager?.startMonitoringSignificantLocationChanges()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
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
    
    private func cleanRoot() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.strokeWidth = 5
        route?.strokeColor = .green
        route?.map = mapView
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.view.layer.opacity = 0.5
        
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        mapView.animate(to: position)
        
        let point = LastRootPoint()
        point.lat = location.coordinate.latitude
        point.long = location.coordinate.longitude
        
        self.rootCoordinates.append(point)
        
        beginBackgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.beginBackgroundTask!)
            self.beginBackgroundTask = .invalid
        }
        
        print("Coordinates are: \(location.coordinate.latitude) \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
