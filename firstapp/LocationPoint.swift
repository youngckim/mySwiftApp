//
//  LocationPoint.swift
//  firstapp
//
//  Created by young kim on 7/29/25.
//

import CoreLocation
import MapKit

struct LocationPoint: Identifiable, Equatable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let timestamp: Date
    
    static func == (lhs: LocationPoint, rhs: LocationPoint) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        let loc1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let loc2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return loc1.distance(from: loc2) // in meters
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    //@Published var locations: [CLLocation] = []
    @Published var points: [LocationPoint] = []
    
    private var lastRecordTime: Date? = nil

    override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        guard let latest = newLocations.last else { return }
        let now = Date()
        if let last = lastRecordTime {
            if now.timeIntervalSince(last) >= 300 {
                addPoint(from: latest, at: now)
            }
        } else {
            addPoint(from: latest, at: now)
        }
    }

    private func addPoint(from loc: CLLocation, at time: Date) {
        DispatchQueue.main.async {
            if let last = self.points.last {
                let distance = last.coordinate.distance(to: loc.coordinate)
                let minutes = time.timeIntervalSince(last.timestamp) / 60

                // Only add if at least 5 minutes passed and 10 meters moved
                if minutes >= 5 && distance > 10 {
                    self.points.append(LocationPoint(coordinate: loc.coordinate, timestamp: time))
                    self.lastRecordTime = time
                }
            } else {
                // First point
                self.points.append(LocationPoint(coordinate: loc.coordinate, timestamp: time))
                self.lastRecordTime = time
            }
        }
    }

}
