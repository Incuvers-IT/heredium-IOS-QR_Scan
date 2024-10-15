//
//  LocationManager.swift
//  app
//
//  Created by Muune on 2022/12/07.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    

    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var status: CLAuthorizationStatus? = .notDetermined
    static let shared = LocationManager()
    // 위치 권한 업데이트
    public let locationAuthChange = PassthroughSubject<CLAuthorizationStatus, Never>()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    func requestLocation() {
        if(manager.authorizationStatus == .denied){
            print("위치 비허용")
            status = manager.authorizationStatus
        }
        
        manager.requestWhenInUseAuthorization()
    }
    
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        self.status = status
        
        switch status {
        case .notDetermined:
            print("DEBUG: Not determined")
        case .restricted:
            print("DEBUG: Restricted")
        case .denied:
            print("DEBUG: Denied")
        case .authorizedAlways:
            print("DEBUG: Auth always")
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use")
        @unknown default:
            break
        }
        
        locationAuthChange.send(status)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
       
    }
}
