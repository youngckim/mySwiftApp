import SwiftUI
import MapKit

struct MapHistoryView: View {
    @EnvironmentObject var locationManager: LocationManager

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @State private var selectedIndex: Int? = nil

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: numberedPoints()) { point in
            MapAnnotation(coordinate: point.coordinate) {
                VStack(spacing: 4) {
                    // Show popup if selected
                    if selectedIndex == point.index {
                        VStack(spacing: 2) {
                            Text("#\(point.index)")
                                .font(.caption)
                                .bold()
                            Text(point.coordinateString)
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text(point.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                    }

                    // Numbered pin
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 30, height: 30)
                        Text("\(point.index)")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .onTapGesture {
                        // Toggle selection
                        selectedIndex = (selectedIndex == point.index) ? nil : point.index
                    }
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

    // Sort and number points
    func numberedPoints() -> [NumberedPoint] {
        let sorted = locationManager.points.sorted(by: { $0.timestamp < $1.timestamp })
        return sorted.enumerated().map { (i, point) in
            NumberedPoint(
                id: UUID(),
                index: i + 1,
                coordinate: point.coordinate,
                timestamp: point.timestamp
            )
        }
    }
}

// NumberedPoint with timestamp and coordinate string
struct NumberedPoint: Identifiable {
    let id: UUID
    let index: Int
    let coordinate: CLLocationCoordinate2D
    let timestamp: Date

    var coordinateString: String {
        String(format: "📍 %.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }
}
