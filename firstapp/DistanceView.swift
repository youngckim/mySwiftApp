import SwiftUI
import CoreLocation

struct DistanceView: View {
    @StateObject private var locationManager = LocationManager()

    var totalDistanceInMiles: Double {
        let coords = locationManager.points.map { $0.coordinate }
        guard coords.count > 1 else { return 0 }

        var distanceMeters: Double = 0
        for i in 1..<coords.count {
            let loc1 = CLLocation(latitude: coords[i-1].latitude, longitude: coords[i-1].longitude)
            let loc2 = CLLocation(latitude: coords[i].latitude, longitude: coords[i].longitude)
            distanceMeters += loc1.distance(from: loc2)
        }
        return distanceMeters / 1609.34  // Convert to miles
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Total Distance Traveled:")
                .font(.title2)
            Text(String(format: "%.2f miles", totalDistanceInMiles))
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding()
        .navigationTitle("Distance")
    }
}
