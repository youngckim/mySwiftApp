//
//  JSONContentView.swift
//  firstapp
//
//  Created by young kim on 7/29/25.
//


import SwiftUI

struct JSONContentView: View {
    @State private var jsonText: String = ""

    var body: some View {
        ScrollView {
            Text(jsonText)
                .font(.system(.body, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Raw JSON")
        .onAppear(perform: loadJSON)
    }

    func loadJSON() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("locations.json")

        do {
            let data = try Data(contentsOf: fileURL)
            jsonText = String(data: data, encoding: .utf8) ?? "⚠️ Unable to decode JSON text"
        } catch {
            jsonText = "❌ Error loading file:\n\(error.localizedDescription)"
        }
    }
}
