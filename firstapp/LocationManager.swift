//
//  LocationManager.swift
//  firstapp
//
//  Created by young kim on 7/29/25.
//
import CoreLocation
import MapKit



class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var points: [LocationPoint] = [] {
        didSet { savePoints() }
    }

    private let saveFileURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("locations.json")
    }()

    override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyBest
        loadPoints()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        guard let latest = newLocations.last else { return }
        let now = Date()
        if let last = points.last {
            let distance = last.coordinate.distance(to: latest.coordinate)
            let minutes = now.timeIntervalSince(last.timestamp) / 60
            if minutes >= 5 && distance > 10 {
                addPoint(from: latest, at: now)
            }
        } else {
            addPoint(from: latest, at: now)
        }
    }

    private func addPoint(from loc: CLLocation, at time: Date) {
        let newPoint = LocationPoint(coordinate: loc.coordinate, timestamp: time)

        DispatchQueue.main.async {
            if let last = self.points.last {
                let distance = last.coordinate.distance(to: newPoint.coordinate)
                let minutes = time.timeIntervalSince(last.timestamp) / 60.0

                // Only add if it's 5+ minutes OR distance > 10 meters
                if minutes >= 5 || distance > 10 {
                    self.points.append(newPoint)
                }
            } else {
                // First point
                self.points.append(newPoint)
            }
        }
    }


    private func savePoints() {
        do {
            let data = try JSONEncoder().encode(points)
            try data.write(to: saveFileURL)
        } catch {
            print("❌ Failed to save locations: \(error)")
        }
    }

    private func loadPoints() {
        do {
            let data = try Data(contentsOf: saveFileURL)
            let loaded = try JSONDecoder().decode([LocationPoint].self, from: data)
            self.points = loaded
        } catch {
            print("⚠️ No existing history or failed to load: \(error)")
            self.points = []
        }
    }
}
