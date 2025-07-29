//
//  ContentView.swift
//  firstapp
//
//  Created by young kim on 7/26/25.
//

import SwiftUI
import CoreLocation
import MapKit


struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                NavigationLink("Show history on Map") {
                    MapHistoryView()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("Total distance") {
                    DistanceView()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
            .navigationTitle("Location Tracker")
        }
    }
}




