//
//  DeleteHistoryView.swift
//  firstapp
//
//  Created by young kim on 7/29/25.
//


import SwiftUI

struct DeleteHistoryView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var showConfirm = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Delete all saved location history?")
                .font(.title2)

            Button("Delete History") {
                showConfirm = true
            }
            .foregroundColor(.red)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Delete History")
        .alert("Are you sure?", isPresented: $showConfirm) {
            Button("Delete", role: .destructive) {
                locationManager.clearHistory()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove all saved locations permanently.")
        }
    }
}
