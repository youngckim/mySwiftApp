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
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locationManager.points) { point in
            MapAnnotation(coordinate: point.coordinate) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.blue)
            }
        }
        .onAppear {
            if let first = locationManager.points.last {
                region.center = first.coordinate
            }
        }
        .onChange(of: locationManager.points.count) { _ in
            if let last = locationManager.points.last {
                region.center = last.coordinate
            }
        }
        .ignoresSafeArea()
    }
}

