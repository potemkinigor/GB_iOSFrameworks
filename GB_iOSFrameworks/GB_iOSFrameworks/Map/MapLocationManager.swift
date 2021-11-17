//
//  MapLocationManager.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 17.11.2021.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class MapLocationManager: NSObject {
    static let instance = MapLocationManager()
    
    let locationManager = CLLocationManager()
    
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    private override init() {
        super.init()
        self.configureLocationManager()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func configureLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
    }
    
}

extension MapLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location.accept(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
