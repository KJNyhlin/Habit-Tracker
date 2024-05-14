//
//  HabitListView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-03.
//  Det är den här versionen som gäller nu. 

import SwiftUI
import CoreData

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @Binding var showingDetail: Bool
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                NavigationLink(destination: ItemDetailView(item: item)
                    .onDisappear { showingDetail = false }
                    .onAppear { showingDetail = true }) {
                        HStack {
                            Text(item.name ?? "Unnamed Habit")
                            Spacer()
                            Text("Streak: \(item.streak)")
                            Spacer()
                            Button(action: {
                                markDone(item)
                            }) {
                                Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.done ? .green : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear {
            checkDatesAndUpdateStatus()
        }
        .navigationTitle("My habits")
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let idsToDelete = offsets.map { items[$0].id!.uuidString }
            
            var habitStats = UserDefaults.standard.dictionary(forKey: "habitStatistics") ?? [:]
            for id in idsToDelete {
                if var habitData = habitStats[id] as? [String: Any] {
                    habitData["endDate"] = Date()
                    habitData["isActive"] = false
                    habitStats[id] = habitData
                }
            }
            
            UserDefaults.standard.set(habitStats, forKey: "habitStatistics")
            
            offsets.map { items[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    
    
    
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    
    
    
    private func markDone(_ item: Item) {
        withAnimation {
            if item.done == false {
                item.done.toggle()  // Makes item.done = true (not possible to unmark)
            }
            if item.done {
                item.penultimateDoneDate = item.latestDoneDate
                item.latestDoneDate = Date()  // Updates the latestDoneDate to today
                if isOneDayBefore(item.penultimateDoneDate, comparedTo: item.latestDoneDate) {
                    item.streak += 1
                }
            } else {
                item.latestDoneDate = nil
            }
            saveContext()
        }
    }
    
    
    private func checkDatesAndUpdateStatus() {
        let today = Calendar.current.startOfDay(for: Date())
        for item in items {
            if let latestDoneDate = item.latestDoneDate, Calendar.current.startOfDay(for: latestDoneDate) != today {
                item.done = false
            }
        }
        saveContext()
    }
    
    func isOneDayBefore(_ penultimateDoneDate: Date?, comparedTo latestDoneDate: Date?) -> Bool {
        guard let penultimateDoneDate = penultimateDoneDate,
              let latestDoneDate = latestDoneDate else {
            return false  // Om något av datumen är nil
        }
        
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day]
        
        let penultimateComponents = calendar.dateComponents(components, from: penultimateDoneDate)
        let latestComponents = calendar.dateComponents(components, from: latestDoneDate)
        
        if let penultimateDay = calendar.date(from: penultimateComponents),
           let nextDay = calendar.date(byAdding: .day, value: 1, to: penultimateDay),
           let latestDay = calendar.date(from: latestComponents) {
            return nextDay == latestDay
        }
        
        return false
    }
    
}
