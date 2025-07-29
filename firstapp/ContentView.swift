//
//  ContentView.swift
//  firstapp
//
//  Created by young kim on 7/26/25.
//
import SwiftUI

// Place this near the top of ContentView



struct ContentView: View {
    @State private var clearDays: Int = 7
    let dayOptions = Array(1...90)
    
    @EnvironmentObject var locationManager: LocationManager
    //@State private var clearDays: Int = 7
    @State private var showClearConfirm = false
    @State private var showUndoBanner = false
    @State private var deletedBackup: [LocationPoint] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                NavigationLink("Show history on Map") {
                    MapHistoryView()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("Total distance") {
                    DistanceView()
                }
                .buttonStyle(.bordered)

                NavigationLink("Location history") {
                    LocationListView()
                }
                .buttonStyle(.bordered)

                NavigationLink("View content of JSON") {
                    JSONContentView()
                }
                .buttonStyle(.bordered)

                NavigationLink("Delete All History") {
                    DeleteHistoryView()
                }
                .buttonStyle(.bordered)

                // ✅ Clear older than X days, inline
                HStack(spacing: 10) {
                    Text("Clear older than")

                    Picker("Days", selection: $clearDays) {
                        ForEach(dayOptions, id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 80)
                    .clipped()

                    Text("days")

                    Button("Clear") {
                        showClearConfirm = true
                    }
                    .foregroundColor(.red)
                    .buttonStyle(.borderedProminent)
                }
                .font(.subheadline)
                .padding(.top)

                Spacer()
            }
            .padding()
            .navigationTitle("Location Tracker")
            .alert("Delete entries older than \(clearDays) days?", isPresented: $showClearConfirm) {
                Button("Delete", role: .destructive) {
                    let cutoff = Date().addingTimeInterval(Double(-clearDays * 24 * 60 * 60))
                    let all = locationManager.points
                    let kept = all.filter { $0.timestamp >= cutoff }
                    let deleted = all.filter { $0.timestamp < cutoff }

                    locationManager.points = kept
                    deletedBackup = deleted
                    showUndoBanner = true

                    // Auto-clear backup
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        deletedBackup = []
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .overlay(alignment: .bottom) {
                if showUndoBanner && !deletedBackup.isEmpty {
                    VStack {
                        Text("Deleted \(deletedBackup.count) entr\(deletedBackup.count == 1 ? "y" : "ies")")
                        Button("Undo") {
                            locationManager.points += deletedBackup
                            deletedBackup = []
                            showUndoBanner = false
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding()
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showUndoBanner)
                }
            }
        }
    }
}
