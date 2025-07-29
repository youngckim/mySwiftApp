//
//  firstappApp.swift
//  firstapp
//
//  Created by young kim on 7/26/25.
//

import SwiftUI

@main
struct firstappApp: App {
    @StateObject private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }
}
