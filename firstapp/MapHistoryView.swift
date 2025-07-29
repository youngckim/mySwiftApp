//
//  MapHistoryView.swift
//  firstapp
//
//  Created by young kim on 7/29/25.
//
import SwiftUI
import MapKit

struct MapHistoryView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locationManager.points) { point in
            MapPin(coordinate: point.coordinate, tint: .blue)
        }
        .onChange(of: locationManager.points.count) { _ in
            if let last = locationManager.points.last {
                region.center = last.coordinate
            }
        }
        .ignoresSafeArea()
    }
}
