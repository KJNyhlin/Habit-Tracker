//
//  HabitListView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-03.
//

import SwiftUI

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @Binding var showingDetail: Bool

    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(destination: ItemDetailView(item: item)
                    .onDisappear { showingDetail = false }
                    .onAppear { showingDetail = true }) {
                        HStack {
                            Text(item.name ?? "Unnamed Habit")
                            Spacer()
                            Text("Streak: \(item.streak)")
                            
                                .buttonStyle(PlainButtonStyle()) // Förhindrar knappens standard beteende i listan
                            
                            Spacer()
                            
                            // Button för att markera habit som "done"
                            Button(action: {
                                markDone(item)
                            }) {
                                Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.done ? .green : .gray)
                            }
                            .buttonStyle(PlainButtonStyle()) // Se till att knappen inte triggar navigation
                        }}}
        
                .onDelete(perform: deleteItems)
            }
            //.navigationTitle("Habits")
            .onAppear {
                checkDatesAndUpdateStatus()
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

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func markDone(_ item: Item) {
            withAnimation {
                item.done.toggle()  // Toggles the 'done' state
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
                //print(item)
            }
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
    
    
    struct HabitListView_Previews: PreviewProvider {
        static var previews: some View {
            EmptyView()
        }
    }
    
}
