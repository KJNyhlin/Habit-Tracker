//
//  AddHabitView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-06.
//

import Foundation

import SwiftUI

public struct AddHabitView: View {

    @Binding var habitName: String
    @Binding var showingSheet: Bool
    var onSave: () -> Void // Callback-stängning för att anropa addItem()

    public init(habitName: Binding<String>, showingSheet: Binding<Bool>, onSave: @escaping () -> Void) {
        _habitName = habitName
        _showingSheet = showingSheet
        self.onSave = onSave
    }

    public var body: some View {
        VStack {
            TextField("Name your new habit", text: $habitName)
                .onChange(of: habitName) { newValue in
                    print("Habit name changed to: \(newValue)")
                }
                .onSubmit {
                    onSave()
                    habitName = ""  // Rensa habitName direkt efter att den har sparats
                    showingSheet = false
                }
            //Button("Save") {
            //    onSave() // Anropa callback-stängningen för att spara habiten
            //    showingSheet = false // Stänger sheeten
            //}
        }
        .padding()
    }
}


