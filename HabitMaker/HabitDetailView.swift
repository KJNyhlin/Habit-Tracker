//
//  HabitDetailView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-07.
//

import Foundation

import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var item: Item

    var body: some View {
        VStack {
            Text("Details for \(item.name ?? "Ingen titel")")
            //Text("Done today: \(item.done ? "Yes" : "No")")
            if let date = item.latestDoneDate {
                Text("Last done: \(date, formatter: itemDateFormatter)")
            }
            Text("Current streak: \(item.streak)")
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

let itemDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()
