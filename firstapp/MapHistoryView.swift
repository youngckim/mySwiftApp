import SwiftUI
import MapKit

struct MapHistoryView: View {
    @EnvironmentObject var locationManager: LocationManager

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: numberedPoints()) { point in
            MapAnnotation(coordinate: point.coordinate) {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                    Text("\(point.index)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
        .onAppear {
            if let last = locationManager.points.last {
                region.center = last.coordinate
            }
        }
        .ignoresSafeArea()
    }

    // Sorted oldest to newest, index starts at 1
    func numberedPoints() -> [NumberedPoint] {
        let sorted = locationManager.points.sorted(by: { $0.timestamp < $1.timestamp })
        return sorted.enumerated().map { (i, point) in
            NumberedPoint(index: i + 1, coordinate: point.coordinate)
        }
    }
}

struct NumberedPoint: Identifiable {
    let id = UUID()
    let index: Int
    let coordinate: CLLocationCoordinate2D
}
