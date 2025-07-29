//
//  LocationListView.swift
//  firstapp
//
//  Created by young kim on 7/29/25.
//


import SwiftUI
import CoreLocation

struct LocationListView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        List(locationManager.points.reversed()) { point in
            VStack(alignment: .leading) {
                Text("Lat: \(point.coordinate.latitude), Lon: \(point.coordinate.longitude)")
                    .font(.body)
                Text("Time: \(formattedDate(point.timestamp))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Location History")
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
