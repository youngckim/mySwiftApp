//
//  DeleteHistoryView.swift
//  firstapp
//
//  Created by young kim on 7/29/25.
//


import SwiftUI

struct DeleteHistoryView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss

    @State private var showConfirm = false
    @State private var showUndoMessage = false
    @State private var deletedPointsBackup: [LocationPoint] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Delete all saved location history?")
                .font(.title2)

            Button("Delete History") {
                showConfirm = true
            }
            .foregroundColor(.red)
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Delete History")
        .alert("Are you sure?", isPresented: $showConfirm) {
            Button("Delete", role: .destructive) {
                deletedPointsBackup = locationManager.points
                locationManager.clearHistory()
                showUndoMessage = true

                // Auto-dismiss after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    dismiss()
                }

                // Auto-clear undo buffer after 10 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    deletedPointsBackup = []
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove all saved locations permanently.")
        }
        .overlay(alignment: .bottom) {
            if showUndoMessage && !deletedPointsBackup.isEmpty {
                VStack {
                    Text("History deleted")
                        .padding(.bottom, 4)

                    Button("Undo") {
                        locationManager.restoreHistory(from: deletedPointsBackup)
                        deletedPointsBackup = []
                        showUndoMessage = false
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding()
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showUndoMessage)
            }
        }
    }
}

