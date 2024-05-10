//
//  ContentView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-04-30.
//
// TODO: Önskvärda förbättringar:
// 1. Design!!!
// 2. Ta ev bort möjligheten att avmarkera "done", logiken för streaks är inte helt vattentät om man markerar och avmarkerar flera gånger.
// 3. Fixa statistiksidan så att den visar mer utförlig info.


import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingSheet = false
    @State private var habitName = ""
    @State private var showingDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                if !showingDetail {
                    HStack {
                        Text("Habit name")
                        Spacer()
                        Text("Streak")
                        Spacer()
                        Text("Done today")
                    }
                    .padding()
                }
                HabitListView(showingDetail: $showingDetail)
                
                NavigationLink(destination: StatisticsView()) {
                    Text("My Statistics")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                // for testing, remove before release
                //Button("Add Test Items") {
                //    addTestItems()
                //}
            }
            .toolbar {
                //ToolbarItem(placement: .navigationBarTrailing) {
                //   EditButton()
                //}
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.showingSheet = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                AddHabitView(habitName: $habitName, showingSheet: $showingSheet) {
                    addItem()
                }
            }
        }
    }
    
    
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.timestamp = Date()  // Datum när vanan skapas
            newItem.streak = 0
            newItem.done = false
            newItem.name = habitName
            
            // Update stats in UserDefaults
            updateStatisticsFor(newItem)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    private func updateStatisticsFor(_ item: Item) {
        var statistics = UserDefaults.standard.dictionary(forKey: "habitStatistics") as? [String: [String: Any]] ?? [:]
        let key = "\(item.id!.uuidString)_\(item.timestamp!.formatted(date: .numeric, time: .omitted))"
        statistics[key] = [
            "date": item.timestamp!,
            "name": item.name!,
            "streak": item.streak,
            // Lägg till tidigare streaks och andra detaljer som behövs
            "previousStreaks": item.name == "Äta nyttig mat" ? [3, 4] : []
        ]
        UserDefaults.standard.set(statistics, forKey: "habitStatistics")
    }
    
    
    private func addTestItems() {
        // Ändra manuellt datumsträngarna för när varje vana började
        let dateStrings = ["2024-03-20", "2024-04-12", "2024-05-03"]
        let names = ["Löpträning", "Äta nyttig mat", "Läsa en bok"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
        
        withAnimation {
            for (index, dateString) in dateStrings.enumerated() {
                if let startDate = dateFormatter.date(from: dateString) {
                    let newItem = Item(context: viewContext)
                    newItem.id = UUID()
                    newItem.timestamp = startDate
                    newItem.name = names[index]
                    newItem.done = false
                    
                    // Sätt unika egenskaper för varje testobjekt
                    switch newItem.name {
                    case "Löpträning":
                        newItem.streak = 42  // Avslutat streak på 6 veckor
                        newItem.timestamp = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) // Nystartat streak
                    case "Äta nyttig mat":
                        newItem.streak = 14 // Pågående streak på 2 veckor
                        // Äldre streaks kan simulera via UserDefaults här om nödvändigt
                    case "Läsa en bok":
                        newItem.streak = 0  // Inget pågående streak
                        newItem.timestamp = Calendar.current.date(byAdding: .day, value: -3, to: Date()) // Avslutades för 3 dagar sedan
                    default:
                        break
                    }
                    
                    // Update UserDefaults för att simulera historiska data
                    updateStatisticsFor(newItem)
                }
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    
    
    
    
    
    let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let timeZone = TimeZone(identifier: "Europe/Stockholm") {
            formatter.timeZone = timeZone
        } else {
            print("Failed to set timezone")
        }
        //formatter.dateStyle = .short
        //formatter.timeStyle = .none
        return formatter
    }()
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    struct AddHabitView_Previews: PreviewProvider {
        static var previews: some View {
            EmptyView() // Kringgå felmeddelandet
        }
    }
    
}
